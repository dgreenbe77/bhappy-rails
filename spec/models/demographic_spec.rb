require 'spec_helper'

describe Demographic do

  describe 'demographic comparisons' do

    it 'should compare age ranges' do
      FactoryGirl.create(:happiness_log, happy_scale: 10)
      FactoryGirl.create(:happiness_log, happy_scale: 0, min_age: 15, max_age: 25)
      expect(Demographic.compare_age_ranges(5, 15, 15, 25)).to include "People Between Ages 5 and 15 are Happier \n than People Between Ages 15 and 25"
    end

    it 'should compare genders' do
      FactoryGirl.create(:happiness_log, happy_scale: 10)
      FactoryGirl.create(:happiness_log, happy_scale: 1, gender: "Female", gender_confidence: 100)
      expect(Demographic.compare_genders).to include "Males are Happier than Females"
    end

    it 'should compare smiling to frowning' do
      FactoryGirl.create(:happiness_log, happy_scale: 10, smile: 100)
      FactoryGirl.create(:happiness_log, happy_scale: 0, smile: 1)
      expect(Demographic.compare_smiles).to include "People who Smile are Happier than Those Who Frown"
    end

  end

end
