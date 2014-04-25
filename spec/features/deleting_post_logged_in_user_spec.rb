require 'spec_helper'

feature 'deleting a happiness post', %Q{
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
    visit '/happy'
  end

  context "editing a page that has been posted" do

    it 'enables you to edit a post' do 
      click_on 'Destroy'
      expect(current_path).to eq '/happy'
      visit '/happy'
      expect(page).to_not have_content(@happiness_log.main_post)
    end

  end
end
