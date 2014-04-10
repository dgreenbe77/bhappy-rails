require 'spec_helper'

describe 'WordAnalysis' do
  
  describe 'word data analysis' do

    before(:each) do
      @user = FactoryGirl.build(:user)
      @info = FactoryGirl.build(:info, user: @user)
      WordAnalysis.init(@info, @user, ['positive'])
    end

    it 'should return correct word count based on word bank' do
      WordAnalysis.word_analysis('positive')
      expect(@info.positive).to eq(2.0)
      expect(@info.negative).to eq(0.0)
      info2 = FactoryGirl.build(:info, main_post: "negative hate bad")
      WordAnalysis.init(info2, @user)
      WordAnalysis.word_analysis('negative')
      expect(info2.positive).to eq(0.0)
      expect(info2.negative).to eq(3.0)
    end

    it 'should create a scale based on the word count, standard deviation, and normal distribution' do
      WordAnalysis.count_and_scale
      expect(@info.positive_scale).to eq(5.0)
      info2 = FactoryGirl.create(:info, main_post: 'hi a+ happy hi a+ happy hi a+ happy hi a+ happy hi a+ happy hi a+ happy hi a+ happy hi a+ happy!')
      WordAnalysis.init(info2, @user, ['positive'])
      WordAnalysis.count_and_scale
      expect(info2.positive_scale).to eq(10.0)
      info3 = FactoryGirl.create(:info, main_post: 'bad, bad, bad, bad')
      WordAnalysis.init(info3, @user, ['positive'])
      WordAnalysis.count_and_scale
      expect(info3.positive_scale).to eq(2.0)
    end

  end

end
