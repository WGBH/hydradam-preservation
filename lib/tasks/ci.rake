require 'preservation/dev_tools'
require 'rspec/core/rake_task'

task :ci => ['engine_cart:generate'] do
  Preservation::DevTools.with_servers('test') do
    RSpec::Core::RakeTask.new(:spec)
    Rake::Task['spec'].invoke
  end
end
