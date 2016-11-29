require 'rails_helper'

describe Preservation do
  describe '::VERSION' do
    it 'contains the semantic version of the gem' do
      # TODO: allow release candidate syntaxes?
      expect(Preservation::VERSION).to match(/\d+\.\d+\.\d+/)
    end
  end
end
