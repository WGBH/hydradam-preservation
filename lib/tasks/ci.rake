require 'preservation/service_support'
require 'rspec/core/rake_task'

task :ci => ['engine_cart:generate'] do
  Preservation::ServiceSupport.new(env: 'test').wrap do
    RSpec::Core::RakeTask.new(:spec)
    Rake::Task['spec'].invoke
  end
end
