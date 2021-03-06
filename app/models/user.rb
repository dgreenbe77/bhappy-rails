class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :omniauthable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :happiness_logs
  has_one :location, dependent: :delete

  serialize :work
  serialize :affiliations
  serialize :education
  serialize :languages
  serialize :sports
  validates_uniqueness_of :email, allow_blank: true, if: :email_changed?, message: 'may have been signed up through another service'

  def self.from_omniauth(auth)
    add_posts_to_social_media_user(auth)
    where(auth.slice(:provider, :uid)).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.oauth_token = auth.credentials.token
      if auth.provider == 'twitter'
        self.twitter_sign_up(user, auth)
      else
        self.facebook_sign_up(user, auth)
      end
    end
  end

  def self.add_posts_to_social_media_user(auth)
    member = where(auth.slice(:provider, :uid)).first
    unless member.nil?
      member.oauth_token = auth.credentials.token
      if auth.provider == 'twitter'
        make_twitter_happiness_log(member, auth)
      else
        graph = Koala::Facebook::API.new(member.oauth_token)
        fql = graph.fql_query("SELECT pic_big FROM user WHERE uid = me()")
        make_facebook_happiness_log(member, graph, fql)
      end
    end
  end

  def self.twitter_sign_up(user, auth)
    user.email = auth.extra.raw_info.screen_name + "@twitter.com"
    user.secret_oauth_token = auth.credentials.secret
    user.current_location = auth.info.location 
    user.friend_count = auth.extra.raw_info.friends_count
    make_twitter_happiness_log(user, auth)
    user.save!
  end

  def self.facebook_sign_up(user, auth)
    user.email = auth.info.email
    user.oauth_expires_at = Time.at(auth.credentials.expires_at)
    user.hometown = auth.extra.raw_info.hometown.name
    user.work = auth.extra.raw_info.work
    graph = Koala::Facebook::API.new(user.oauth_token)
    fql = graph.fql_query("SELECT pic_big, friend_count, activities, affiliations, birthday, books, current_address, current_location, education, interests, languages, movies, music, political, profile_blurb, quotes, religion, sports, tv FROM user WHERE uid = me()")
    ['friend_count', 'activities', 'affiliations', 'birthday', 'books', 'current_address', 'current_location', 'education', 'interests', 
     'languages', 'movies', 'music', 'political', 'profile_blurb', 'quotes', 'religion', 'sports', 'tv'].each {|category| user[category] = fql[0][category]} 
    make_facebook_happiness_log(user, graph, fql)
    user.save!
  end

  def self.make_twitter_happiness_log(user, auth)
    client = set_twitter_client(user, auth)
    happiness_log = grab_twitter_posts(user, client)
    analysis = WordAnalysis.new(happiness_log, user)
    analysis.count_and_scale
    happiness_log.happy = happiness_log.positive_scale - happiness_log.negative_scale
    happiness_log.happy_scale = analysis.convert_scale_by_deviation('happy')
    happiness_log.save!
  end

  def self.set_twitter_client(user, auth)
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV["twitter_key"]
      config.consumer_secret     = ENV["twitter_secret"]
      config.access_token        = auth.credentials.token
      config.access_token_secret = auth.credentials.secret
    end
    return client
  end

  def self.grab_twitter_posts(user, client)
    happiness_log = HappinessLog.new(title: "Twitter", address: 'Twitter', user: user)
    if !client.user_timeline.slice(2).text.blank?
      happiness_log.main_post = client.user_timeline.slice(2).text + client.user_timeline.slice(1).text + client.user_timeline.first.text
    elsif !client.user_timeline.slice(1).text.blank?
      happiness_log.main_post = client.user_timeline.slice(1).text + client.user_timeline.first.text
    elsif !client.user_timeline.first.text.blank?
      happiness_log.main_post = client.user_timeline.first.text
    else
      happiness_log.main_post = "No Tweets"
    end
    return happiness_log
  end

  def self.make_facebook_happiness_log(user, graph, fql)
    user.image = fql[0]['pic_big']
    happiness_log = HappinessLog.new(title: 'Facebook Facial Recognition Analysis', main_post: 'Facebook', address: 'Facebook', image: user.image, user: user)
    FacialRecognition.api(happiness_log, WordAnalysis.new(happiness_log, user))
    happiness_log.save!
  end

  def self.new_with_session(params, session)
    if session["devise.user_attributes"]
      new(session["devise.user_attributes"], without_protection: true) do |user|
        user.attributes = params
        user.valid?
      end
    else
      super
    end
  end

  def password_required?
    super && provider.blank?
  end

  def update_with_password(params, *options)
    if encrypted_password.blank?
      update_attributes(params, *options)
    else
      super
    end
  end

end
