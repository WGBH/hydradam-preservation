require 'preservation'
require 'solr_wrapper'
require 'fcrepo_wrapper'
require 'active_support/core_ext/hash/keys'

module Preservation
  class ServiceEnvironment
    attr_reader :env

    def initialize(env)
      @env = (env || 'development').to_s
    end

    def start
      wrap do
        begin
          puts "\nServices started. Ctrl+C to stop.\n\n"
          sleep
        rescue Interrupt
          # TODO: Why doesn't this message get printed?
          puts "Stopping services..."
        end
      end
    end

    def wrap
      SolrWrapper.wrap(solr_wrapper_config) do |solr_wrapper_instance|
        # If a solr collection exists, but is not configured to persist,
        # then we must delete it before we try to re-create it. Otherwise
        # SolrWrapper with throw an error. Note this is kind of an awkward
        # way to check for existence of the core, but it's due to current
        # limitation of the SolrWrapper interfaces.
        if !solr_wrapper_config[:collection][:persist] && SolrWrapper::Client.new(solr_wrapper_instance.url).exists?(solr_wrapper_config[:collection][:name])
          solr_wrapper_instance.delete solr_wrapper_config[:collection][:name]
        end

        solr_wrapper_instance.with_collection(solr_wrapper_config[:collection]) do
          FcrepoWrapper.wrap(fcrepo_wrapper_config) do
            yield
          end
        end
      end
    end

    private

    def solr_wrapper_config
      @solr_wrapper_config ||= YAML.load(File.read(solr_wrapper_config_path)).deep_symbolize_keys
    end

    def solr_wrapper_config_path
      File.join(Preservation.root, ".solr_wrapper.#{env}.yml")
    end

    def fcrepo_wrapper_config
      @fcrepo_wrapper_config ||= YAML.load(File.read(fcrepo_wrapper_config_path)).deep_symbolize_keys
    end

    def fcrepo_wrapper_config_path
      File.join(Preservation.root, ".fcrepo_wrapper.#{env}.yml")
    end
  end
end
