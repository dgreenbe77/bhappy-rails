require 'spec_helper'

describe Location do

  describe 'Associations' do

    it {should belong_to :user}

  end

end
