require 'rails_helper'

describe Preservation::Event do
  it 'has a factory' do
    expect(FactoryGirl.create(:event)).to be_a Preservation::Event
  end

  describe '#premis_event_type_label' do
    let(:premis_event_type) { Preservation::Event.premis_event_types.sample }
    it 'returns the label of the premis event type' do

    end
  end
end
