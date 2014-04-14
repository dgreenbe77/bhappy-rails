class WorldController < ApplicationController
  respond_to :html, :json

  def index
    if params.keys.include?('email')
      @user = User.where(email: params['email']).first
      @happiness_logs = @user.happiness_logs
    else
      @user = current_user
      @happiness_logs = HappinessLog.all
    end

    gon.happiness_logs = @happiness_logs
    gon.date = @happiness_logs.pluck(:created_at)
    @location = Location.new

    unless @user.blank?
      unless @user.location.blank?
        gon.region = @user.location.region
      end
    end
  end

  def create
    if params.keys.include?('email')
      @user = User.where(email: params['email']).first
      @happiness_log = HappinessLog.new(title: params['title'], main_post: params['main_post'], address: params['address'])
      @happiness_log.user = @user
      analysis = WordAnalysis.new(@happiness_log, @user)
      analysis.count_and_scale
      @happiness_log.happy = @happiness_log.positive_scale - @happiness_log.negative_scale
      @happiness_log.happy_scale = analysis.convert_scale_by_deviation('happy')
      @happiness_log.save
      redirect_to '/world'
    end
  end

end
