require 'factory_girl'

# Load gem's factories explicitly instead of simply calling
# FactoryGirl.find_definitions. This is to allow us to load factories in the
# host app, as well as from the gem's test suite.
Dir.glob(File.expand_path('../../factories/**/*.rb', __FILE__)).each do |factory_def_file|
  begin
    load factory_def_file
  rescue FactoryGirl::DuplicateDefinitionError => e
    # Rescue from any repeated FactoryGirl definitions and log the message.
    Rails.logger.warn "#{e.message}... skipping *ALL* definitions found in #{factory_def_file}."
  end
end

# FactoryGirl factories may be used outside of RSpec context, e.g. for
# creating sample data in host app when running demos. So wrap RSpec config in
# a conditional.
if defined?(RSpec) && RSpec.respond_to?(:configure)
  RSpec.configure do |config|
    config.include FactoryGirl::Syntax::Methods
  end
end
