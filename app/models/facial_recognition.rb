class FacialRecognition

  def self.api(info)
    unless info.image.blank? || info.image == "Add Image"
      uri = URI::encode(info.image)
      @response = Unirest::get("https://faceplusplus-faceplusplus.p.mashape.com/detection/detect?url=#{uri}&attribute=smiling",
      headers:{
        "X-Mashape-Authorization" => ENV['face_plus_api_key']
      })
      unless @response.body.keys.include?('error')
        face = @response.body["face"]
        info.smile = (face[0]["attribute"]["smiling"]["value"])/20
      end
    end
  end

end
