require 'preservation'
require 'psych'
require 'solr_wrapper'

module Preservation
  module DevTools
    class SolrService
      attr_reader :env, :config_path, :log

      def initialize(opts={})
        raise ArgumentError, "First argument must be a hash of options, but #{opts.class} was given." unless opts.respond_to?(:key?)
        @config_path = opts.delete(:config_path)
        @env = opts.delete(:env) || 'development'
      end

      def config
        @config ||= begin
          # Note the use of #reduce here is just to convert string keys to
          # symbols becasue SolrWrapper internals won't recognize string keys.
          YAML.load(File.read(config_path)).reduce({}) { |memo,(k,v)| memo[k.to_sym] = v; memo }
        end
      end

      def config_path
        @config_path ||= File.join(Preservation.root, ".solr_wrapper.#{env}.yml")
      end

      def start
        puts "Starting Solr using SolrWrapper with config from #{config_path}:\n#{config.to_yaml}"
        solr_wrapper_instance.start
        puts "Solr started."
        puts "Ensuring Solr collection exists using config values:\n#{config[:collection].to_yaml}"
        solr_wrapper_instance.create(config[:collection]) if config.key?(:collection)
        puts "Solr collection existence verified."
      end

      private

      def solr_wrapper_instance
        @solr_wrapper_instance ||= SolrWrapper::Instance.new(config)
      end
    end
  end
end
