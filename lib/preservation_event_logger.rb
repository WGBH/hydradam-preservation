# TODO: Only use this as-is for Demo. If you want to use it as a service object
# it should be moved to a different location probably.
module Preservation
  class EventLogger
    def self.log_preservation_event(opts={})
      Preservation::Event.new.tap do |pe|
        pe.premis_event_type += [Preservation::Event.premis_event_types[opts[:premis_event_type].to_sym]]
        pe.premis_event_related_object = opts[:file_set]
        # Assume opts[:premis_agent] is an email address, and make a 'mailto:' RDF::URI out of it.
        pe.premis_agent += [::RDF::URI.new("mailto:#{opts[:premis_agent]}")]
        pe.premis_event_date_time += [opts[:premis_event_date_time]]
        pe.save!
      end
    end
  end
end