begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

load 'rails/tasks/statistics.rake'
require 'bundler/gem_tasks'
require 'engine_cart/rake_task'

# Load rake tasks defined in files under lib/tasks/ ending in '.rake'.
Dir.glob(File.expand_path('../lib/tasks/**/*.rake', __FILE__)) do |file|
  load file
end

task :default => ['preservation:ci']
