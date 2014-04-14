require 'spec_helper'

describe FacialRecognition do
  
  it 'returns facial analysis data when given a valid image url' do
    happiness_log = FactoryGirl.build(:happiness_log)
    happiness_log.image = "https://scontent-b-lga.xx.fbcdn.net/hphotos-prn1/t1.0-9/1604450_10151970999657690_1220460635_n.jpg"
    FacialRecognition.api(happiness_log)
    expect(happiness_log.smile).to_not be_blank
  end

  it 'returns no facial analysis data when given an invalid url' do
    happiness_log = FactoryGirl.build(:happiness_log)
    FacialRecognition.api(happiness_log)
    expect(happiness_log.smile).to be_blank
    happiness_log.image = "ajfoawoeoiewr"
    FacialRecognition.api(happiness_log)
    expect(happiness_log.smile).to be_blank
  end

end
