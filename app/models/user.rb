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
    where(auth.slice(:provider, :uid)).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.email = auth.info.email
      user.hometown = auth.extra.raw_info.hometown.name
      user.work = auth.extra.raw_info.work
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      graph = Koala::Facebook::API.new(user.oauth_token)
      fql = graph.fql_query("SELECT pic_big, friend_count, activities, affiliations, birthday, books, current_address, current_location, education, interests, languages, movies, music, political, profile_blurb, quotes, religion, sports, tv FROM user WHERE uid = me()")
      user.image = fql[0]['pic_big'] 
      user.friend_count = fql[0]['friend_count'] 
      user.activities = fql[0]['activities'] 
      user.affiliations = fql[0]['affiliations'] 
      user.birthday = fql[0]['birthday'] 
      user.books = fql[0]['books'] 
      user.current_address = fql[0]['current_address'] 
      user.current_location = fql[0]['current_location'] 
      user.education = fql[0]['education'] 
      user.interests = fql[0]['interests'] 
      user.languages = fql[0]['languages'] 
      user.movies = fql[0]['movies'] 
      user.music = fql[0]['music'] 
      user.political = fql[0]['political'] 
      user.profile_blurb = fql[0]['profile_blurb'] 
      user.quotes = fql[0]['quotes'] 
      user.religion = fql[0]['religion'] 
      user.sports = fql[0]['sports'] 
      user.tv = fql[0]['tv'] 
      happiness_log = HappinessLog.new(title: 'Welcome!', main_post: '- From the Bhappy Team', address: '', image: user.image, user: user)
      FacialRecognition.api(happiness_log, WordAnalysis.new(happiness_log, user))
      user.save!
    end
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

# <div id="user_nav">
#       <% if current_user %>
#         Signed in as <strong><%= current_user.name %></strong>!
#         <%= link_to "Sign out", signout_path, id: "sign_out" %>
#       <% else %>
#         <%= link_to "Sign in with Facebook", "/auth/facebook", id: "sign_in" %>
#       <% end %>
#     </div>
end
