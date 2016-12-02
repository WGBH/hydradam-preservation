require "preservation/engine" if defined? ::Rails

module Preservation
  def self.root
    File.expand_path('../../', __FILE__)
  end
end
