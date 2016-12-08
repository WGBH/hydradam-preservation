require 'preservation/service_support'

namespace :services do
  task :start, [:env] do |t, args|
    env = args[:env] || 'development'
    Preservation::ServiceSupport.new(env: env).start
  end

  task :stop, [:env] do |t, args|
    env = args[:env] || 'development'
    Preservation::ServiceSupport.new(env: env).stop
  end

  task :restart, [:env] do |t, args|
    env = args[:env] || 'development'
    Preservation::ServiceSupport.new(env: env).restart
  end
end
