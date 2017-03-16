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

    # @return [String] the label of the PREMIS event type that corresponds
    #   with the URI from the first value of the #premis_event_type property.
    def premis_event_type_label
      premis_event_type_object.label
    end

    def premis_event_type_abbr
      premis_event_type_object.abbr
    end

    def self.indexer
      EventIndexer
    end

    private
      # @return [Preservation::PremisEventType] first PremisEventType instance
      #   found where Preservation::PremisEventType#uri matches first value
      #   found in #premis_event_type property.
      def premis_event_type_object
        @premis_event_type_object ||= Preservation::PremisEventType.find_by_uri(premis_event_type.first.id)
      end
  end
end
