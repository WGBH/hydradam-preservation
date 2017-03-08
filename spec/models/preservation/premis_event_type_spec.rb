require 'rails_helper'

describe Preservation::PremisEventType do
  let(:premis_event_type) { Preservation::PremisEventType.new('cap') }
  let(:premis_event_type_uri_namespace) { 'http://id.loc.gov/vocabulary/preservation/eventType/' }

  describe '#uri' do
    it 'returns an RDF::Vocabulary::Term' do
      expect(premis_event_type.uri).to be_a ::RDF::Vocabulary::Term
    end

    it 'returns a URI under the PREMIS Event Type namespace when converted to a string' do
      expect(premis_event_type.uri.to_s).to match /#{premis_event_type_uri_namespace}/
    end
  end

  describe '.all' do
    it 'returns an array of PremisEventType instances' do
      Preservation::PremisEventType.all.each do |premis_event_type|
        expect(premis_event_type).to be_a Preservation::PremisEventType
      end
    end
  end
end
