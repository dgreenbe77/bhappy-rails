require 'spec_helper'

describe Question do
  
  describe 'Validations' do

    it {should have_valid(:main_postq).when("What?")}
    it {should_not have_valid(:main_postq).when("", nil)}
    it {should validate_uniqueness_of(:main_postq)}

  end

end
