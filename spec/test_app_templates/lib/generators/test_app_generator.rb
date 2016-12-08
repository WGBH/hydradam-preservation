require 'rails/generators'

class TestAppGenerator < Rails::Generators::Base
  source_root File.join(Preservation.root, "spec", "test_app_templates")

  def install_curation_concerns
    generate 'curation_concerns:install -f'
  end

  def install_engine
    generate 'preservation:install'
  end
end
