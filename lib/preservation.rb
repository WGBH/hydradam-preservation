if defined? Rails
  require "preservation/engine"
  require 'curation_concerns'
end

module Preservation
  def self.root
    Pathname.new(File.expand_path('../../', __FILE__))
  end
end
