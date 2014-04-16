class FacialRecognition

  def self.api(happiness_log, analysis)
    unless happiness_log.image.blank? || happiness_log.image == "Add Image"
      uri = URI::encode(happiness_log.image)
      @response = Unirest::get("https://faceplusplus-faceplusplus.p.mashape.com/detection/detect?url=#{uri}&attribute=gender%2Cage%2Crace%2Csmiling",
      headers:{
        "X-Mashape-Authorization" => ENV['face_plus_api_key']
      })
      unless @response.body.keys.include?('error')
        attributes = @response.body["face"][0]["attribute"]
        happiness_log.smile = attributes["smiling"]["value"]
        happiness_log.smile_scale = analysis.convert_scale_by_deviation('smile')
        range = attributes['age']['range']
        age = attributes['age']['value']
        happiness_log.min_age = age - range
        happiness_log.max_age = age + range
        happiness_log.race = attributes['race']['value']
        happiness_log.race_confidence = attributes['race']['confidence']
        happiness_log.gender = attributes['gender']['value']
        happiness_log.gender_confidence = attributes['gender']['confidence']
      end
    end
  end

end
