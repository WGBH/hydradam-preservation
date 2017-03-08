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

  describe '.find_by_uri' do
    context 'when there is a corresponding instance that matches the URI passed in' do
      let(:lookup_uri) { 'http://id.loc.gov/vocabulary/preservation/eventType/mes' }
      it 'returns the instance' do
        expect(Preservation::PremisEventType.find_by_uri(lookup_uri).uri.to_s).to eq lookup_uri
      end
    end

    context 'when there is no corresponding record for the URI' do
      let(:lookup_uri) { 'invalid-premis-event-type-uri' }
      it 'raises a Preservation::PremisEventType::NotFound error' do
        expect { Preservation::PremisEventType.find_by_uri(lookup_uri) }.to raise_error Preservation::PremisEventType::NotFound
      end
    end
  end
end
