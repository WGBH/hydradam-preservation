module Preservation
  class Event < ActiveFedora::Base
    type ::RDF::Vocab::PREMIS.Event

    belongs_to :premis_event_related_object, predicate: ::RDF::Vocab::PREMIS.hasEventRelatedObject, class_name: FileSet

    property :premis_event_type, predicate: ::RDF::Vocab::PREMIS.hasEventType
    property :premis_agent, predicate: ::RDF::Vocab::PREMIS.hasAgent
    property :premis_event_date_time, predicate: ::RDF::Vocab::PREMIS.hasEventDateTime
    property :premis_event_outcome, predicate: ::RDF::Vocab::PREMIS.hasEventOutcome
    property :premis_event_detail, predicate: ::RDF::Vocab::PREMIS.hasEventDetail

    def user_from_db
      @user_from_db ||= User.where(email: premis_agent)
    end

    def self.indexer
      EventIndexer
    end
  end
end
