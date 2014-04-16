require 'spec_helper'

describe Question do
  
  describe 'Validations' do

    it {should have_valid(:positiveq).when("What?")}
    it {should_not have_valid(:positiveq).when("", nil)}

    it 'should validate  uniqueness of questions' do
      FactoryGirl.create(:question)
      new_questions = FactoryGirl.build(:question)
      expect(new_questions).to_not be_valid
      expect(new_questions.errors[:positiveq]).to_not be_blank
      expect(new_questions.errors[:negativeq]).to_not be_blank          
    end

    it {should have_valid(:negativeq).when("What?")}
    it {should_not have_valid(:negativeq).when("", nil)}

  end

end
