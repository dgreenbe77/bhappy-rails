class HappinessLogsController < ApplicationController
  before_action :set_happiness_log, only: [:show, :edit, :update, :destroy]
  before_action :set_user
  before_action :authenticate_user!, :except => [:index, :world]
  protect_from_forgery with: :exception
  # respond_to :html, :json

  def index
  end

  def show
    @happiness_logs = @user.happiness_logs
    @location = Location.new

    unless @happiness_log.image.blank? || @happiness_log.image == 'Add Image'
      uri = URI::encode(@happiness_log.image)
      @response = Unirest::get("https://faceplusplus-faceplusplus.p.mashape.com/detection/detect?url=#{uri}&attribute=glass%2Cpose%2Cgender%2Cage%2Crace%2Csmiling",
      headers:{
        "X-Mashape-Authorization" => ENV['face_plus_api_key']
      })
    end

    gon.current_happiness_log = @happiness_log
    gon.happiness_logs = @happiness_logs
    gon.date = @happiness_logs.pluck(:created_at)

    unless @user.location.blank?
      gon.region = @user.location.region
    end
  end

  def logs
    if user_signed_in?
      @happiness_logs = @user.happiness_logs.order(created_at: :desc).page params[:page]
    else
      @happiness_logs = []
    end
  end

  def search
    query = "%#{params[:Query]}%"
    @happiness_logs = HappinessLog.where('main_post like :match or address like :match or title like :match', match: query)
  end

  def new
    @happiness_log = HappinessLog.new
  end

  def edit
  end

  def create
    @happiness_log = HappinessLog.new(happiness_log_params)
    @user.happiness_logs << @happiness_log
    FacialRecognition.api(@happiness_log)
    analysis = WordAnalysis.new(@happiness_log, @user)
    analysis.count_and_scale
    @happiness_log.happy = @happiness_log.positive_scale - @happiness_log.negative_scale
    @happiness_log.happy_scale = analysis.convert_scale_by_deviation('happy')
    respond_to do |format|
      if @happiness_log.save
        format.html { redirect_to @happiness_log }
        format.json { render action: 'show', status: :created, location: @happiness_log }
      else
        format.html { render action: 'new' }
        format.json { render json: @happiness_log.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @happiness_log.update(happiness_log_params)
        format.html { redirect_to @happiness_log }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @happiness_log.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @happiness_log.destroy
    respond_to do |format|
      format.html { redirect_to happiness_logs_url }
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
      params.require(:happiness_log).permit(:address, :main_post, :image, :title)
    end

end
