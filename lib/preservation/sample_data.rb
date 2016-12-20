require 'factory_girl'

# Load all factories from spec/factories.
Dir.glob("#{File.expand_path('../../../spec/factories', __FILE__)}/**/*.rb").each do |factory_file|
  load factory_file
end

module Preservation
  class SampleData
    attr_reader :records

    def initialize
      @records = []
    end

    def create(factory_name, count=1)
      count.times { @records << FactoryGirl.create(factory_name) }
      @records[-(count)..-1]
    end

    def destroy_all!
      @records.each do |record|
        record.destroy
      end
      @records = []
    end
  end
end
