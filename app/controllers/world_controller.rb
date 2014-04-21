class WorldController < ApplicationController

  def create
    user = params['world']
    if user.keys.include?('email')
      @user = User.where(email: user['email']).first
      @happiness_log = HappinessLog.new(title: user['title'], main_post: user['main_post'], address: user['address'])
      @happiness_log.user = @user
      analysis = WordAnalysis.new(@happiness_log, @user)
      analysis.count_and_scale
      @happiness_log.happy = @happiness_log.positive_scale - @happiness_log.negative_scale
      @happiness_log.happy_scale = analysis.convert_scale_by_deviation('happy')
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

end
