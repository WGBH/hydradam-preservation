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
  end
end
