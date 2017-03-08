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

    # Returns an array of instances of all known PREMIS event types
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
  end
end
