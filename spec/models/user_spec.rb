require 'spec_helper'

describe User do

  describe 'Associations' do

    it {should have_one :location}
    it {should have_many :infos}

  end

end
