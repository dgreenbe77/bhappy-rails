class FacialRecognition

  def self.api(happiness_log)
    unless happiness_log.image.blank? || happiness_log.image == "Add Image"
      uri = URI::encode(happiness_log.image)
      @response = Unirest::get("https://faceplusplus-faceplusplus.p.mashape.com/detection/detect?url=#{uri}&attribute=smiling",
      headers:{
        "X-Mashape-Authorization" => ENV['face_plus_api_key']
      })
      unless @response.body.keys.include?('error')
        face = @response.body["face"]
        happiness_log.smile = (face[0]["attribute"]["smiling"]["value"])/20
      end
    end
  end

end
