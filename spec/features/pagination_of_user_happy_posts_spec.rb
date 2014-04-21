require 'spec_helper'

feature 'pagination of posts listing', %q{
As a registered user
I want to see my posts in sets of 5 on the page (or 20, or any #, whatevs)
So the page doesn't have to load too much happiness logs at a time and isn't overwhelmed
} do
# AC:
# When a user views the home page the listings are paginated, and can click to "see next X listings"

  before(:each) do
    @user = FactoryGirl.create(:user)
    sign_in_as(@user)
    FactoryGirl.create(:happiness_log, main_post: "Comercialization makes me a sad sad panda", user: @user)
    FactoryGirl.create_list(:happiness_log, 4, user: @user)
    visit '/happy/logs'
  end

  context 'pagination' do

    it 'only displays 5 posts postings a page' do
      expect(page).to have_content("Comercialization makes me a sad sad panda")
      FactoryGirl.create(:happiness_log, user: @user)
      visit '/happy/logs'
      expect(page).to_not have_content("Comercialization makes me a sad sad panda")
    end

  end

end
