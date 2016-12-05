require 'preservation/dev_tools/fcrepo_service'

describe Preservation::DevTools::FcrepoService do
  describe '#start' do
    let(:fcrepo_service) { described_class.new(fcrepo_wrapper_instance: mock_fcrepo_wrapper_instance) }
    let(:mock_fcrepo_wrapper_instance) { double(FcrepoWrapper::Instance) }

    before do
      allow(fcrepo_service).to receive(:fcrepo_wrapper_instance).and_return(mock_fcrepo_wrapper_instance)
      allow(mock_fcrepo_wrapper_instance).to receive(:start).and_return(nil)
    end

    it 'calls FcrepoWrapper::Instance#start' do
      expect(mock_fcrepo_wrapper_instance).to receive(:start).exactly(1).times
      fcrepo_service.start
    end
  end
end
