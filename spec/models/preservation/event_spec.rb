require 'rails_helper'

describe Preservation::Event do
  it 'has a factory' do
    expect(FactoryGirl.create(:event)).to be_a Preservation::Event
  end
end
