require 'preservation'
require 'solr_wrapper'
require 'fcrepo_wrapper'

module Preservation
  class ServiceSupport
    attr_reader :env

    def initialize(opts={})
      raise ArgumentError, "#{self.class} constructor expects first argument to be a Hash of options, but #{opts.class} was given." unless opts.respond_to?(:keys)
      @env = opts.delete(:env) || 'development'
    end

    def start
      start_solr
      start_fcrepo
    end

    def stop
      stop_solr
      stop_fcrepo
    end

    def restart
      stop
      start
    end

    def wrap
      SolrWrapper.wrap(solr_wrapper_config) do |solr_wrapper_inst|
        solr_wrapper_inst.with_collection(solr_wrapper_config[:collection]) do
          FcrepoWrapper.wrap(fcrepo_wrapper_config) do
            yield
          end
        end
      end
    end

    private

    def start_solr
      solr_wrapper_instance.start
      if solr_wrapper_config[:collection]
        solr_wrapper_instance.create(solr_wrapper_config[:collection])
      end
    end

    def stop_solr
      return unless solr_wrapper_instance.status
      solr_wrapper_instance.delete(solr_wrapper_config[:collection][:name]) unless solr_wrapper_config[:collection][:persist]
      solr_wrapper_instance.stop
    end

    def solr_wrapper_instance
      @solr_wrapper_instance ||= SolrWrapper::Instance.new(solr_wrapper_config)
    end

    def solr_wrapper_config
      @solr_wrapper_config ||= YAML.load(File.read(solr_wrapper_config_path)).deep_symbolize_keys
    end

    def solr_wrapper_config_path
      File.join(Preservation.root, ".solr_wrapper.#{env}.yml")
    end

    def start_fcrepo
      fcrepo_wrapper_instance.start
    end

    def fcrepo_wrapper_instance
      @fcrepo_wrapper_instance || FcrepoWrapper::Instance.new(fcrepo_wrapper_config)
    end

    def fcrepo_wrapper_config
      @fcrepo_wrapper_config ||= YAML.load(File.read(fcrepo_wrapper_config_path)).deep_symbolize_keys
    end

    def fcrepo_wrapper_config_path
      File.join(Preservation.root, ".fcrepo_wrapper.#{env}.yml")
    end

    def stop_fcrepo
      puts "FCRepo must be killed manually at this time."
    end

    # def self.with_servers(env)
    #   raise ArgumentError, "Block expected but none given" unless block_given?
    #   solr_wrapper_config = File.join(Preservation.root, ".solr_wrapper.#{env}.yml")
    #   SolrWrapper.wrap(config: solr_wrapper_config, verbose: true) do |solr_wrapper|
    #     solr_wrapper.create()
    #       fcrepo_wrapper_config = File.join(Preservation.root, ".fcrepo_wrapper.#{env}.yml")
    #       FcrepoWrapper.wrap(config: fcrepo_wrapper_config) do
    #         yield
    #       end
    #     end
          
    #   end
    # end
  end
end
