require 'factory_girl'

FactoryGirl.find_definitions

# FactoryGirl factories may be used outside of RSpec context, e.g. for
# creating sample data for running demos. So wrap RSpec config in a
# conditional.
if defined? RSpec
  RSpec.configure do |config|
    config.include FactoryGirl::Syntax::Methods
  end
end
