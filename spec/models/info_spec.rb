require 'spec_helper'

describe HappinessLog do
  
  describe 'Validations' do

    it {should have_valid(:main_post).when("Life is good")}
    it {should_not have_valid(:main_post).when("", nil)}

    it {should have_valid(:address).when("Boston")}
    it {should_not have_valid(:address).when("", nil)}

    it {should have_valid(:title).when("Hella good post")}
    it {should_not have_valid(:title).when("", nil)}

  end

  describe 'Associations' do

    it {should belong_to :user}

  end

end
