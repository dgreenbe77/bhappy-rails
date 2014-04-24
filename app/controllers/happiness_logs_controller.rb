class HappinessLogsController < ApplicationController
  before_action :set_happiness_log, only: [:show, :edit, :update, :destroy]
  before_action :set_user
  before_action :authenticate_user!, :except => [:index]
  protect_from_forgery with: :exception

  def index
    if user_signed_in?
      @happiness_logs = @user.happiness_logs.order(created_at: :desc).page params[:page]
    else
      @happiness_logs = []
    end
  end

  def show
    @happiness_logs = @user.happiness_logs
    @location = Location.new
    gon.current_happiness_log = @happiness_log
    gon.happiness_logs = @happiness_logs
    gon.date = @happiness_logs.pluck(:created_at)

    unless @user.location.blank?
      gon.region = @user.location.region
    end
  end

  def search
    query = "%#{params[:Query]}%"
    @happiness_logs = @user.happiness_logs.where('main_post like :match or address like :match or title like :match', match: query)
  end

  def new
    @question = Question.random_question
    @happiness_log = HappinessLog.new
  end

  def edit
    @question = Question.random_question
  end

  def create
    @happiness_log = HappinessLog.new(happiness_log_params)
    @user.happiness_logs << @happiness_log
    happiness_log_analysis

    respond_to do |format|
      if @happiness_log.save
        format.html { redirect_to @happiness_log }
        format.json { render action: 'show', status: :created, location: @happiness_log }
      else
        format.html { redirect_to new_happiness_log_path, notice: "Field(s) Left Blank or Invalid"}
        format.json { render json: @happiness_log.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @happiness_log.update(happiness_log_params)
    happiness_log_analysis

    respond_to do |format|
      if @happiness_log.update(happiness_log_params)
        format.html { redirect_to @happiness_log }
        format.json { head :no_content }
      else
        format.html { redirect_to edit_happiness_log_path, notice: "Field(s) Left Blank or Invalid" }
        format.json { render json: @happiness_log.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @happiness_log.destroy
    respond_to do |format|
      format.html { redirect_to happiness_logs_url}
      format.json { head :no_content }
    end
  end

  private
    def set_happiness_log
      @happiness_log = HappinessLog.find(params[:id])
    end

    def set_user
      @user = current_user
    end

    def happiness_log_params
      params.require(:happiness_log).permit(:question, :address, :main_post, :image, :title)
    end

    def learning_filter(analysis)
      if Question.where(positiveq: params[:question]).exists? && @happiness_log.happy_scale > 8
        analysis.learning('positive')
      elsif Question.where(negativeq: params[:question]).exists? && @happiness_log.happy_scale < 2
        analysis.learning('negative')     
      end
    end

    def happiness_log_analysis
      analysis = WordAnalysis.new(@happiness_log, @user)
      analysis.count_and_scale
      @happiness_log.happy = @happiness_log.positive_scale - @happiness_log.negative_scale
      @happiness_log.happy_scale = analysis.convert_scale_by_deviation('happy')
      learning_filter(analysis)
      FacialRecognition.api(@happiness_log, analysis)
    end

end
