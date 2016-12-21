require 'rails_helper'

describe 'Preservation Events details page' do
    let(:preservation_event) { create(:event) }

    it 'displays the PREMIS event type' do
      visit "preservation/events/#{preservation_event.id}"
      premis_event_type_label = Preservation::Event.premis_event_type(preservation_event.premis_event_type.first.to_uri.to_s).label
      expect(page).to have_text(premis_event_type_label)
    end
end
