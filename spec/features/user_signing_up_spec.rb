require 'spec_helper'

feature 'viewer signing up', %q{
  As an unregistered user,
  I can sign up for the website
  So I can be happy and stop trolling good people} do

# AC:
# I must enter a previously unregistered email
# I must enter a password
# I must enter the same password in the confirmation field
# The website has a sign up button

  context 'filling out user information' do

  before(:each) do
    @user = FactoryGirl.build(:user)
  end

    it 'allows you to sign up when you give valid entries' do
      visit '/'
      click_on 'Sign Up'
      fill_in "Email", with: @user.email
      fill_in "Password", with: @user.password
      fill_in "Password confirmation", with: @user.password
      within "#new_user" do
        click_on "Sign up"
      end

      expect(page).to have_content('Welcome! You have signed up successfully.')
      expect(page).to have_content('Sign Out')
    end


    it "gives you an error message when you don't give it an email" do
      visit new_user_registration_path
      fill_in "Email", with: ""
      fill_in "Password", with: @user.password
      fill_in "Password confirmation", with: @user.password
      within "#new_user" do
        click_on "Sign up"
      end

      within "#new_user" do
        expect(page).to have_button("Sign up")
      end
      expect(page).to have_content("Email can't be blank")
    end

    it "gives you an error message when you don't give it an password" do
      visit new_user_registration_path
      fill_in "Email", with: @user.email
      fill_in "Password", with: ""
      fill_in "Password confirmation", with: ""
      within "#new_user" do
        click_on "Sign up"
      end

      within "#new_user" do
        expect(page).to have_button("Sign up")
      end
      expect(page).to have_content("Password can't be blank")
    end

    it "gives you an error when you enter in email that was already registered" do
      User.create!(email: 'user@shlomo.com', password: 'adminqwerty')
      visit new_user_registration_path
      fill_in "Email", with: "user@shlomo.com"
      fill_in "Password", with: "adminqwerty"
      fill_in "Password confirmation", with: "adminqwerty"
      within "#new_user" do
        click_on "Sign up"
      end

      within "#new_user" do
        expect(page).to have_button("Sign up")
      end
      expect(page).to have_content("Email has already been taken")
    end

  end

end
