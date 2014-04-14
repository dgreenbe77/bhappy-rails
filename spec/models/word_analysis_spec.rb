require 'spec_helper'

describe 'WordAnalysis' do
  
  describe 'word data analysis' do

    before(:each) do
      @user = FactoryGirl.build(:user)
      @happiness_log = FactoryGirl.build(:happiness_log, user: @user)
      @analysis = WordAnalysis.new(@happiness_log, @user, ['positive'])
    end

    it 'should return correct word count based on word bank' do
      @analysis.word_analysis('positive')
      expect(@happiness_log.positive).to eq(2.0)
      expect(@happiness_log.negative).to eq(0.0)
      happiness_log2 = FactoryGirl.build(:happiness_log, main_post: "negative hate bad")
      analysis2 = WordAnalysis.new(happiness_log2, @user)
      analysis2.word_analysis('negative')
      expect(happiness_log2.positive).to eq(0.0)
      expect(happiness_log2.negative).to eq(3.0)
    end

    it 'should create a scale based on the word count, standard deviation, and normal distribution' do
      @analysis.count_and_scale
      expect(@happiness_log.positive_scale).to eq(5.0)
      happiness_log2 = FactoryGirl.create(:happiness_log, main_post: 'hi a+ happy hi a+ happy hi a+ happy hi a+ happy hi a+ happy hi a+ happy hi a+ happy hi a+ happy!')
      analysis2 = WordAnalysis.new(happiness_log2, @user, ['positive'])
      analysis2.count_and_scale
      expect(happiness_log2.positive_scale).to eq(10.0)
      happiness_log3 = FactoryGirl.create(:happiness_log, main_post: 'bad, bad, bad, bad')
      analysis3 = WordAnalysis.new(happiness_log3, @user, ['positive'])
      analysis3.count_and_scale
      expect(happiness_log3.positive_scale).to eq(2.0)
    end

  end

end
