require 'factory_girl'
require 'support/factory_girl'

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

    # Calls #destroy on all objects in @records.
    # NOTE: This may not delete associated objects.
    def destroy_all!
      @records.each do |record|
        record.destroy
      end
      @records = []
    end
  end
end
