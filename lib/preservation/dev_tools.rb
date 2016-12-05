require 'preservation/dev_tools/solr_service'
require 'preservation/dev_tools/fcrepo_service'

module Preservation
  module DevTools
    def self.with_servers(env)
      SolrService.new(env: env).tap do |solr_service|
        solr_service.wrap do
          FcrepoService.new(env: env).tap do |fcrepo_service|
            fcrepo_service.wrap do
              yield
            end
          end
        end
      end
    end
  end
end
