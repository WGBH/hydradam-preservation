require 'preservation/dev_tools/solr_service'

describe Preservation::DevTools::SolrService do
  describe '#start' do
    let(:mock_solr_wrapper_config_yaml) do
      {
        instance_dir: "example_solr_instance_dir",
        port: 9999,
        collection: {
          persist: true,
          dir: 'example_solr_config_dir',
          name: 'example_solr_collection_name'
        }
      }.to_yaml
    end

    let(:mock_config_file) do
      Tempfile.new('example_solr_wrapper_config').tap do |f|
        f.write(mock_solr_wrapper_config_yaml)
        f.close
      end
    end

    let(:config_path) { mock_config_file.path }
    let(:solr_service) { described_class.new(config_path: config_path) }
    let(:mock_solr_wrapper_instance) { instance_double(SolrWrapper::Instance) }

    before do
      allow(solr_service).to receive(:solr_wrapper_instance).and_return(mock_solr_wrapper_instance)
    end

    it 'calls SolrWrapper::Instance#start and SolrWrapper::Instance#create with correct config' do
      expect(mock_solr_wrapper_instance).to receive(:start).exactly(1).times
      expect(mock_solr_wrapper_instance).to receive(:create).with(solr_service.config[:collection]).exactly(1).times
      solr_service.start
    end
  end
end
