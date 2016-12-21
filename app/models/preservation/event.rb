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

    # Comprehensive list of all PREMIS event types.
    def self.premis_event_types
      @premis_event_types = [
        PremisEventType.new('cap', 'PREMIS Capture'),
        PremisEventType.new('com', 'PREMIS Compression'),
        PremisEventType.new('cre', 'PREMIS Creation'),
        PremisEventType.new('dea', 'PREMIS Deaccession'),
        PremisEventType.new('dec', 'PREMIS Decryption'),
        PremisEventType.new('del', 'PREMIS Deletion'),
        PremisEventType.new('dig', 'PREMIS Digital Signature Validation'),
        PremisEventType.new('fix', 'PREMIS Fixity Check'),
        PremisEventType.new('ing', 'PREMIS Ingestion'),
        PremisEventType.new('mes', 'PREMIS Message Digest Calculation'),
        PremisEventType.new('mig', 'PREMIS Migration'),
        PremisEventType.new('nor', 'PREMIS Normalization'),
        PremisEventType.new('rep', 'PREMIS Replication'),
        PremisEventType.new('val', 'PREMIS Validation'),
        PremisEventType.new('vir', 'PREMIS Virus Check')
      ]
    end

    # Return a PremisEventType given it's abbreviation, label, or URI.
    def self.premis_event_type(abbr_or_label_or_uri)
      premis_event_types.select do |premis_event_type|
        [premis_event_type.abbr.to_sym, premis_event_type.abbr, premis_event_type.label, premis_event_type.uri].include?(abbr_or_label_or_uri)
      end.first
    end
  end
end
