require 'rails_helper'

describe 'Preservation Events search page' do
  before { 12.times { create(:event) } }

  context 'default display' do
    before { visit 'preservation/events' }

    it 'displays up to 10 results' do
      expect(page).to have_css('li.document', count: 10)
    end

    it 'displays the PREMIS event type label for the title' do
      # Make a regex that checks for any PREMIS event type label.
      regex = /(#{Preservation::Event.premis_event_types.map(&:label).join('|')})/
      expect(page).to have_css('h4.index_title a', text: regex)
    end

    it 'displays the PREMIS agent' do
      # TODO: avoid using hardcoded dynamic solr suffix here
      expect(page).to have_css('dt.blacklight-premis_agent_ssim', count: 10)
    end

    it 'displays the date of the event' do
      # TODO: avoid using hardcoded dynamic solr suffix here
      expect(page).to have_css('dt.blacklight-premis_event_date_time_dtsim', count: 10)
    end
  end
end
