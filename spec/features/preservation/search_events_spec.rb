require 'rails_helper'

describe 'Preservation Events search page' do
  before do
    12.times { create(:event) }
  end

  context 'with no user action' do
    it 'displays up 10 results by default' do
      visit 'preservation/events'
      expect(page).to have_css('li.document', count: 10)
    end
  end
end
