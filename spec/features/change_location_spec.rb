require 'spec_helper'

feature 'changing location', %q{
As a site visitor,
I want to change the location of the chart,
So I can see the happy locations near me
} do

  context 'picking new location on world page' do

    before(:each) do 
      @user = FactoryGirl.create(:user)
      sign_in_as(@user)
      visit '/world'
    end

    it 'enables you to change the location to a certain country' do
      select 'United Kingdom', from: 'location[region]'
      click_on 'Change Location'
      expect(@user.location.region).to eq('GB')
    end

    it 'enables you to switch the location back to world view after picking a country' do
      select 'United Kingdom', from: 'location[region]'
      click_on 'Change Location'
      expect(@user.location.region).to eq('GB')
      click_on 'See World'
      expect(Location.last).to eq(nil)
    end

  end

  context 'picking new location on world page' do

    before(:each) do 
      @user = FactoryGirl.create(:user)
      sign_in_as(@user)
      @happiness_log = FactoryGirl.create(:happiness_log, user: @user)
      visit happiness_log_path(@happiness_log)
    end

    it 'enables you to change the location to a certain country' do
      select 'United Kingdom', from: 'location[region]'
      click_on 'Change Region'
      expect(@user.location.region).to eq('GB')
    end

    it 'enables you to switch the location back to world view after picking a country' do
      select 'United Kingdom', from: 'location[region]'
      click_on 'Change Region'
      expect(@user.location.region).to eq('GB')
      click_on 'Show World'
      expect(Location.last).to eq(nil)
    end

  end

end
