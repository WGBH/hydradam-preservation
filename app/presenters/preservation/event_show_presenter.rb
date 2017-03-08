module Preservation
  class EventShowPresenter < Blacklight::ShowPresenter
    def heading
      premis_event_type_abbr = document[Solrizer.solr_name(:premis_event_type, :symbol)].first
      premis_event_type = Preservation::PremisEventType.all.find { |premis_event_type| premis_event_type.abbr == premis_event_type_abbr }
      premis_event_type.label
    end
  end
end
