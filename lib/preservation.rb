require "preservation/engine" if defined? ::Rails
require 'curation_concerns'

module Preservation
  def self.root
    File.expand_path('../../', __FILE__)
  end
end
