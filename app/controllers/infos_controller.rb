class InfosController < ApplicationController
  before_action :set_info, only: [:show, :edit, :update, :destroy]
  before_action :set_user

  def index
  end

  def show
    @infos = @user.infos
    unless @info.image.blank? || @info.image == 'Add Image'
      uri = URI::encode(@info.image)
      @response = Unirest::get("https://faceplusplus-faceplusplus.p.mashape.com/detection/detect?url=#{uri}&attribute=glass%2Cpose%2Cgender%2Cage%2Crace%2Csmiling",
      headers:{
        "X-Mashape-Authorization" => ENV['face_plus_api_key']
      })
    end
    @location = Location.new
    gon.current_info = @info
    gon.infos = @infos.map(&:serializable_hash)
    gon.date = @infos.pluck(:created_at)
    unless @user.location.blank?
      gon.region = @user.location.region
    end
    gon.address = @info.address 
  end

  def logs
    if user_signed_in?
      @infos = @user.infos.order(created_at: :desc).page params[:page]
    else
      @infos = []
    end
  end

  def world
    @infos =  Info.all
    gon.infos = @infos
    gon.date = @infos.pluck(:created_at)
    @location = Location.new
    unless @user.blank?
      unless @user.location.blank?
        gon.region = @user.location.region
      end
    end
    respond_to do |format|
        format.html
        format.json
    end
  end

  def search
    query = "%#{params[:Query]}%"
    @infos = Info.where('main_post like :match or address like :match or title like :match', match: query)
  end

  def new
    @info = Info.new
  end

  def edit
  end

  def create
    @info = Info.new(info_params)
    @user.infos << @info
    FacialRecognition.api(@info)
    WordAnalysis.init(@info, @user)
    WordAnalysis.count_and_scale
    @info.happy = @info.positive_scale - @info.negative_scale
    @info.happy_scale = WordAnalysis.convert_scale_by_deviation('happy')
    respond_to do |format|
      if @info.save
        format.html { redirect_to @info }
        format.json { render action: 'show', status: :created, location: @info }
      else
        format.html { render action: 'new' }
        format.json { render json: @info.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @info.update(info_params)
        format.html { redirect_to @info }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @info.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @info.destroy
    respond_to do |format|
      format.html { redirect_to infos_url }
      format.json { head :no_content }
    end
  end

  private
    def set_info
      @info = Info.find(params[:id])
    end

    def set_user
      @user = current_user
    end

    def info_params
      params.require(:info).permit(:address, :main_post, :image, :title)
    end

end
