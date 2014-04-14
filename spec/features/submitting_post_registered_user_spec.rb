require 'spec_helper'

feature 'registered user filling out form', %q{

  }do
# AC:
# I must fill out a main post
# I must fill out a location
# I can optionally submit an image
# Takes you to the show page when you submit a valid post

  before(:each) do
    sign_in_as(FactoryGirl.create(:user))
    FactoryGirl.create(:question)
    visit new_happiness_log_path
    @happiness_log = FactoryGirl.build(:happiness_log)
  end

  context "filling out form" do

    it 'takes you to the show page when you enter valid information' do
      fill_in 'happiness_log[title]', with: 'Happy Happy Good Post'
      fill_in 'happiness_log[main_post]', with: @happiness_log.main_post
      fill_in 'happiness_log[address]', with: @happiness_log.address
      fill_in 'happiness_log_image', with: ''
      click_on 'Find Happiness'

      expect(page).to have_content("Post Data")
      expect(page).to have_content(@happiness_log.main_post)
    end

    it 'requires a main post and a location' do
      fill_in 'happiness_log[main_post]', with: ''
      fill_in 'happiness_log[address]', with:''
      fill_in 'happiness_log[title]', with: ''
      click_on 'Find Happiness'

      expect(page).to have_content("Main post can't be blank")
      expect(page).to have_content("Address can't be blank")
      expect(page).to have_content("Title can't be blank")      
      expect(page).to have_content("Happy Post")
    end

  end

end
