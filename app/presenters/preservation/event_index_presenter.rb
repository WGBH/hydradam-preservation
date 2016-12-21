module Preservation
  class EventIndexPresenter < Blacklight::IndexPresenter
    def label(field, opts = {})
      Event.premis_event_type(document.first(field)).label
    end
  end
end
