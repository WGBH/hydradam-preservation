require 'preservation/dev_tools/solr_service'
require 'preservation/dev_tools/fcrepo_service'

namespace :services do
  namespace :solr do
    task :start, :env do |t, args|
      Preservation::DevTools::SolrService.new(env: args[:env]).start
    end
  end

  namespace :fcrepo do
    task :start, [:env] do |t, args|
      Preservation::DevTools::FcrepoService.new(env: args[:env]).start
    end
  end

  namespace :all do
    task :start, [:env] do |t, args|
      Rake::Task['services:solr:start'].invoke(args[:env])
      Rake::Task['services:fcrepo:start'].invoke(args[:env])
    end
  end
end
