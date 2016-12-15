require 'rails_helper'

describe 'Preservation Events search page' do
  before { 12.times { create(:event) } }

  context 'with no user action' do
    before { visit 'preservation/events' }

    it 'displays up 10 results by default' do
      expect(page).to have_css('li.document', count: 10)
    end
  end
end
