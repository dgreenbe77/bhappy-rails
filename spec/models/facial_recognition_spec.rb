require 'spec_helper'

describe FacialRecognition do
  
  it 'returns facial analysis data when given a valid image url' do
    info = FactoryGirl.build(:info)
    info.image = "https://scontent-b-lga.xx.fbcdn.net/hphotos-prn1/t1.0-9/1604450_10151970999657690_1220460635_n.jpg"
    FacialRecognition.api(info)
    expect(info.smile).to_not be_blank
  end

  it 'returns no facial analysis data when given an invalid url' do
    info = FactoryGirl.build(:info)
    FacialRecognition.api(info)
    expect(info.smile).to be_blank
    info.image = "ajfoawoeoiewr"
    FacialRecognition.api(info)
    expect(info.smile).to be_blank
  end

end
