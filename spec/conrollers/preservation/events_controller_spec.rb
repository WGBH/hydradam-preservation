require 'rails_helper'

describe Preservation::EventsController, type: :controller do
  # TODO: move to before(:suite) hook in rails_helper?
  routes { Preservation::Engine.routes }

  describe 'GET #index' do
    it 'does not error' do
      get :index
      expect(response).to have_http_status(200)
    end
  end
end
