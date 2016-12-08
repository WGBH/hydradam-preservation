module Preservation
  class InstallGenerator < Rails::Generators::Base

    desc <<-EOS
      This generator makes the following changes to your application:
       1. Adds Preservation routes to your ./config/routes.rb

      Thank you for Installing Blacklight.
    EOS

    # def inject_search_builder_behavior
    #   inject_into_file 'app/models/search_builder.rb', after: "include CurationConcerns::SearchFilters\n" do
    #     "\tinclude Hydradam::SearchBuilderBehavior\n"
    #   end
    # end

    def add_routes
      route "mount Preservation::Engine, at: '/preservation'"
    end
  end
end