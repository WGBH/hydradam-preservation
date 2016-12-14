module Preservation
  class EventPresenter < Blacklight::IndexPresenter
    def label(field, opts = {})
      EventPresenter.premis_event_type_label(document.first(field))
    end

    def self.premis_event_type_label(premis_event_type_uri)
      shortened_field_val = begin
        URI(premis_event_type_uri).path.split('/').last
      rescue ArgumentError
        nil
      end
      # TODO: complete the list of premis event types: http://id.loc.gov/vocabulary/preservation/eventType.html
      labels = {
        'cap' => 'PREMIS Capture',
        'fix' => 'PREMIS Fixity Check',
        'ing' => 'PREMIS Ingestion',
        'val' => 'PREMIS Validation'
      }
      labels[shortened_field_val] || 'unknown premis event type'
    end
  end
end
