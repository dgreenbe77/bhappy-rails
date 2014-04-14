require 'spec_helper'

feature 'search bar for posts', %q{
As registered user
I want to be able to search for my posts
So I can find the ones I'm looking for
} do
# AC:
# A user must enter search criteria into the search field to filter data on those keywords
# They can search by title, description, url

  before(:each) do
    @user = FactoryGirl.create(:user)
    sign_in_as(@user)
    @happiness_log = FactoryGirl.create(:happiness_log)
  end

  context 'entering in search query' do

    it 'filters results based on searh criteria' do
      fill_in 'Query', with: "hi a+ happy!"
      click_on 'Search'
      expect(page).to have_content("hi a+ happy!")
      fill_in 'Query', with: "Garbage"
      click_on 'Search'
      expect(page).to_not have_content("hi a+ happy!")
      expect(page).to_not have_content("Garbage")
      fill_in 'Query', with: "10 lakeville drive, boston, ma 02184"
      click_on 'Search'
      expect(page).to have_content("10 lakeville drive, boston, ma 02184")
    end

  end

end
