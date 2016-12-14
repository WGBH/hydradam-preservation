module Preservation
  class Event < ActiveFedora::Base
    type ::RDF::Vocab::PREMIS.Event

    belongs_to :premis_event_related_object, predicate: ::RDF::Vocab::PREMIS.hasEventRelatedObject, class_name: FileSet

    property :premis_event_type, predicate: ::RDF::Vocab::PREMIS.hasEventType
    property :premis_agent, predicate: ::RDF::Vocab::PREMIS.hasAgent
    property :premis_event_date_time, predicate: ::RDF::Vocab::PREMIS.hasEventDateTime

    def user_from_db
      @user_from_db ||= User.where(email: premis_agent)
    end

    def self.indexer
      EventIndexer
    end

    def self.premis_event_types
      @premis_event_types ||= begin
        {}.tap do |premis_event_types|
          [:cap, :com, :cre, :dea, :dec, :del, :der, :dig, :fix, :ing, :mes,
            :mig, :nor, :rep, :val, :vir].each do |type|
            premis_event_types[type] = ::RDF::Vocab::PremisEventType.send(type)
          end
        end
      end
    end
  end
end