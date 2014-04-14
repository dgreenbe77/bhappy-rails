require 'spec_helper'

describe User do

  describe 'Associations' do

    it {should have_one :location}
    it {should have_many :happiness_logs}

  end

end
