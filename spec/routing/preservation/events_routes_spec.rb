require 'rails_helper'

describe 'routes for Preservation::EventsController', type: :routing do
  routes { Preservation::Engine.routes }
  describe 'GET /events' do
    # TODO: The engine is mounted in the test app under '/preservation'. Is
    # there any way to test routes relative to the mount point?
    it 'routes to search interface for preservation events' do
      expect(get: '/events').to route_to(controller: 'preservation/events', action: 'index')
    end
  end
end
