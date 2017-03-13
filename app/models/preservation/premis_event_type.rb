# A basic PORO model for PREMIS event types.
#
# The data for this model is not persisted to any data store. It is just
# hardcoded (see Preservation::PremisEventyType.all).
#
# While only the URI of a PREMIS event type is stored on the
# Preservation::Event#premis_event_type property, this PORO is used to pair
# the URI with an abbreviation and a label.
module Preservation
  class PremisEventType
    attr_reader :abbr, :label

    def initialize(abbr, label='')
      @abbr = abbr
      @label = label
    end

    def uri
      ::RDF::Vocab::PremisEventType.send(abbr)
    end

    # @return [Array] list of all available PremisEventType instances.
    def self.all
      @all ||= [
        new('cap', 'PREMIS Capture'),
        new('com', 'PREMIS Compression'),
        new('cre', 'PREMIS Creation'),
        new('dea', 'PREMIS Deaccession'),
        new('dec', 'PREMIS Decryption'),
        new('del', 'PREMIS Deletion'),
        new('dig', 'PREMIS Digital Signature Validation'),
        new('fix', 'PREMIS Fixity Check'),
        new('ing', 'PREMIS Ingestion'),
        new('mes', 'PREMIS Message Digest Calculation'),
        new('mig', 'PREMIS Migration'),
        new('nor', 'PREMIS Normalization'),
        new('rep', 'PREMIS Replication'),
        new('val', 'PREMIS Validation'),
        new('vir', 'PREMIS Virus Check')
      ]
    end

    # @param [String] URI to use for comparison. Note #to_s is called on the
    #   param before comparing.
    # @return [Preservation::PremisEventType] first found instance with URI
    #   that matches parameter.
    def self.find_by_uri(uri)
      result = all.find { |record| record.uri.to_s == uri.to_s }
      raise NotFound.new("PremisEventType with URI \"#{uri.to_s}\" was not found") unless result
      result
    end

    # Custom Error Classes
    class NotFound < StandardError; end
  end
end
