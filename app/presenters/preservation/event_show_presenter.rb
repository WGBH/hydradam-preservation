module Preservation
  class EventShowPresenter < Blacklight::ShowPresenter
    def heading
      premis_event_type_abbr = document[Solrizer.solr_name(:premis_event_type, :symbol)].first
      Preservation::Event.premis_event_type(premis_event_type_abbr).label
    end
  end
end
