require 'rails_helper'
require 'support/sample_data'

describe 'Preservation Events search results' do
  before(:all) do
    @sample_data = Preservation::SampleData.new.tap do |sample_data|
      sample_data.create(:event, 12)
    end
  end

  context 'without URL parameters (default)' do
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

    it 'displays a link to the file' do
      expect(page).to have_link('Example File', count: 10)
    end

    context 'filters' do
      it 'has a search filter for date' do
        expect(page).to have_css('form#date_time_range_filter')
      end

      it 'has a search filter for PREMIS event type' do
        expect(page).to have_css('form#premis_event_type_filter')
      end
    end
  end

  context 'filtered by date' do
    # NOTE: we include the `per_page` param and set it to a high number ot ensure we return
    # all records from the sample data set. This helps us to know what to expect on the page
    # without having to work around pagination.
    before { visit "preservation/events?after=2014-01-01&before=2015-01-01&per_page=100" }

    it 'prepopulates input fields for date range filter' do
      expect(page).to have_selector('input[name="after"][value="2014-01-01"]')
      expect(page).to have_selector('input[name="before"][value="2015-01-01"]')
    end

    it 'limits the results to those within the date range' do
      # Here we manually filter out the set of records that fit within the
      # selected date range in order to compare with the set of search results
      # that should be filtered in the same way.
      records_within_date_range = @sample_data.records.select do |record|
        record.premis_event_date_time.first > DateTime.parse('2014-01-01') && record.premis_event_date_time.first < DateTime.parse('2015-01-01')
      end

      records_within_date_range.each do |record|
        expect(page).to have_selector('dd', text: record.premis_event_date_time.first.year)
      end
    end

    it 'does not clobber other filters when new search params are submitted' do
      visit "/preservation/events?premis_event_type[]=fix&premis_event_type[]=cap"
      fill_in "after", with: "2014-01-01"
      first("form#date_time_range_filter button[type='submit']").click
      expect(page).to have_field("premis_event_type_fix", checked: true)
      expect(page).to have_field("premis_event_type_cap", checked: true)
    end
  end

  context 'filtered by PREMIS event type' do
    let(:all_premis_event_types) { Preservation::Event.premis_event_types }
    let(:selected_premis_event_types) { all_premis_event_types.sample(4) }

    before do
      # NOTE: we include the `per_page` param and set it to a high number ot ensure we return
      # all records from the sample data set. This helps us to know what to expect on the page
      # without having to work around pagination.
      url = "preservation/events?per_page=100&"
      url += selected_premis_event_types.map { |t| "premis_event_type[]=#{t.abbr}" }.join('&')
      visit url
    end

    it 'prepopulates input fields for PREMIS event type filter' do
      # If a PREMIS event type is being used in the URL to filter search
      # results, then expect it's checkbox to be checked in the filter form;
      # otherwise do not.
      all_premis_event_types.each do |premis_event_type|
        if selected_premis_event_types.include? premis_event_type
          expect(page).to have_field("premis_event_type_#{premis_event_type.abbr}", checked: true)
        else
          expect(page).to have_field("premis_event_type_#{premis_event_type.abbr}", checked: false)
        end
      end
    end

    it 'limits the results to those of the selected PREMIS event types' do
      # Here we manually filter out the set of records that match the selected
      # PREMIS even types in order to compare with the set of search results
      # that should be filtered in the same way.
      records_with_selected_premis_event_types = @sample_data.records.select do |record|
        selected_premis_event_types.map(&:uri).include? record.premis_event_type.first.id
      end

      # For each of the manually filtered records, expect it to be found among
      # the filtered search results.
      records_with_selected_premis_event_types.each do |record|
        expect(page).to have_selector('h4.index_title a', text: Preservation::Event.premis_event_type(record.premis_event_type.first.id).label)
      end

      # And ensure that none of the non-selected PREMIS event types show up
      (all_premis_event_types - selected_premis_event_types).each do |unselected_premis_event_type|
        expect(page).to_not have_selector('h4.index_title a', text: unselected_premis_event_type.label)
      end
    end
  end

  after(:all) do
    @sample_data.records.each { |e| e.destroy }
  end
end
