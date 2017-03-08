module Preservation
  class EventIndexPresenter < Blacklight::IndexPresenter
    # Returns the value of PremisEventType#label for the PremisEventType instance
    # whose #abbr value matches that which is in the solr document.
    def label(field, opts = {})
      premis_event_type = PremisEventType.all.find { |premis_event_type| premis_event_type.abbr == document.first(field) }
      premis_event_type.label
    end
  end
end
