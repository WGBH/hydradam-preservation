begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

require 'bundler/gem_tasks'
load 'rails/tasks/statistics.rake'
require 'engine_cart/rake_task'

# Load tasks for gem development
Dir.glob('gem_development_rake_tasks/*.rake').each { |r| import r }

# Set the default rake task when developing this gem.
task :default => ['ci']
