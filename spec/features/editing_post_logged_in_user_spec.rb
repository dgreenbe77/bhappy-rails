require 'spec_helper'

feature 'editing a happiness post', %Q{
As an authenticated user,
I can update my post,
So I can fix any mistakes I made
} do 
# AC:
# I have a edit button where it renders the new form. 
# It shows you have successfully updated you post
# It goes to post show page. 
  
  before(:each) do
    @user = FactoryGirl.create(:user)
    sign_in_as(@user)
    @happiness_log = FactoryGirl.create(:happiness_log, user: @user)
    FactoryGirl.create(:question)
    visit '/happy/logs'
    click_on 'Edit'
  end

  context "editing a posts" do

    it 'enables you to edit a post when you fill out valid information' do 
      fill_in 'happiness_log[title]', with: 'Happy Happy Good Post'
      fill_in 'happiness_log[main_post]', with: @happiness_log.main_post
      fill_in 'happiness_log[address]', with: @happiness_log.address
      fill_in 'happiness_log_image', with: ''
      click_on 'Find Happiness'

      expect(page).to have_content("Post Data")
      expect(page).to have_content(@happiness_log.main_post)
    end

    it 'requires a main post' do
      fill_in 'happiness_log[main_post]', with: ''
      fill_in 'happiness_log[address]', with:'Boston'
      fill_in 'happiness_log[title]', with: 'A title'
      click_on 'Find Happiness'

      expect(page).to have_content("Field(s) Left Blank or Invalid")  
      expect(page).to have_content("Edit Log")
    end

    it 'requires a title' do
      fill_in 'happiness_log[main_post]', with: 'Hi hi hi'
      fill_in 'happiness_log[address]', with:'New York'
      fill_in 'happiness_log[title]', with: ''
      click_on 'Find Happiness'

      expect(page).to have_content("Field(s) Left Blank or Invalid")  
      expect(page).to have_content("Edit Log")
    end

    it 'requires a location' do
      fill_in 'happiness_log[main_post]', with: 'Hi hi hi'
      fill_in 'happiness_log[address]', with:''
      fill_in 'happiness_log[title]', with: 'A title'
      click_on 'Find Happiness'

      expect(page).to have_content("Field(s) Left Blank or Invalid")  
      expect(page).to have_content("Edit Log")
    end

  end
end
