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
    visit new_info_path
    @info = FactoryGirl.build(:info)
  end

  context "filling out form" do

    it 'takes you to the show page when you enter valid information' do
      fill_in 'info[title]', with: 'Happy Happy Good Post'
      fill_in 'info[main_post]', with: @info.main_post
      fill_in 'info[address]', with: @info.address
      fill_in 'info_image', with: ''
      click_on 'Find Happiness'

      expect(page).to have_content("Post Data")
      expect(page).to have_content(@info.main_post)
    end

    it 'requires a main post and a location' do
      fill_in 'info[main_post]', with: ''
      fill_in 'info[address]', with:''
      fill_in 'info[title]', with: ''
      click_on 'Find Happiness'

      expect(page).to have_content("Main post can't be blank")
      expect(page).to have_content("Address can't be blank")
      expect(page).to have_content("Title can't be blank")      
      expect(page).to have_content("Happy Post")
    end

  end

end
