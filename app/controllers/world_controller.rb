class WorldController < ApplicationController

  def create
    if params.keys.include?('email')
      @user = User.where(email: params['email']).first
      @happiness_log = HappinessLog.new(title: params['title'], main_post: params['main_post'], address: params['address'])
      @happiness_log.user = @user
      analysis = WordAnalysis.new(@happiness_log, @user)
      analysis.count_and_scale
      @happiness_log.happy = @happiness_log.positive_scale - @happiness_log.negative_scale
      @happiness_log.happy_scale = analysis.convert_scale_by_deviation('happy')
      # redirect_to '/world'

      respond_to do |format|
        if @happiness_log.save
          format.html { redirect_to '/world' }
          format.json { head :no_content }
        else
          format.html { render action: 'new' }
          format.json { render json: @happiness_log.errors, status: :unprocessable_entity }
        end
      end
    end
  end

end
