class WorldController < ApplicationController

  def index
    set_user_for_index
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
    user = params['world']
    if user.keys.include?('email')
      @user = User.where(email: user['email']).first
      create_happiness_log(user)
      
      respond_to do |format|
        if @happiness_log.save
          format.html { redirect_to '/world' }
          format.json { render json: @happiness_log }
        else
          format.html { render action: 'new' }
          format.json { render json: @happiness_log.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  private
    def create_happiness_log(user)
      @happiness_log = HappinessLog.new(title: user['title'], main_post: user['main_post'], address: user['address'])
      @happiness_log.user = @user
      analysis = WordAnalysis.new(@happiness_log, @user)
      analysis.count_and_scale
      @happiness_log.happy = @happiness_log.positive_scale - @happiness_log.negative_scale
      @happiness_log.happy_scale = analysis.convert_scale_by_deviation('happy')
    end

    def set_user_for_index
      if params.keys.include?('email')
        @user = User.where(email: params['email']).first
        @happiness_logs = @user.happiness_logs
      else
        @user = current_user
        @happiness_logs = HappinessLog.all
      end
    end
end
