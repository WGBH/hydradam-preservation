module Preservation
  class Engine < ::Rails::Engine
    isolate_namespace Preservation

    config.autoload_paths += %W(
      #{config.root}/app/helpers
      #{config.root}/app/indexers
      #{config.root}/app/presenters
      #{config.root}/app/search_builders
    )
  end
end
