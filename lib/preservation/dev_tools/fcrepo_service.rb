require 'psych'
require 'fcrepo_wrapper'
require 'active_support/core_ext/hash/indifferent_access'

module Preservation
  module DevTools
    class FcrepoService
      attr_reader :env, :config_path

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
        @config_path ||= File.join(Preservation.root, ".fcrepo_wrapper.#{env}.yml")
      end

      def start
        fcrepo_wrapper_instance.start
      end

      def wrap(&block)
        fcrepo_wrapper_instance.wrap(&block)
      end

      private

      def fcrepo_wrapper_instance
        @fcrepo_wrapper_instance ||= FcrepoWrapper::Instance.new(config)
      end
    end
  end
end
