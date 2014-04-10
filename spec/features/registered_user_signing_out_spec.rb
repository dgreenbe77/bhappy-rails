require 'spec_helper'

feature 'authenticated user signing out', %q{
    As a signed in user
    I want to be able to sign out
    So I can safely end my session} do
# AC:
# The website has a sign out button and confirms successful sign out when clicked

  context 'signed in, want to sign out' do

    it 'should sign out the user' do
      @user = FactoryGirl.create(:user)
      sign_in_as(@user)
      click_on "Sign Out"
      expect(page).to have_content('Signed out successfully')
      expect(page).to have_content('Sign In')
    end

  end

end
