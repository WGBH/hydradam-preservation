require 'preservation/service_environment'

namespace :services do
  task :start, [:env] do |t, args|
    env = args[:env] || 'development'
    Preservation::ServiceEnvironment.new(env).start
  end
end
