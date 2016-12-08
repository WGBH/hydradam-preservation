require 'rails_helper'

describe 'routes for Preservation::EventsController', type: :routing do
  routes { Preservation::Engine.routes }
  describe 'GET /events' do
    # TODO: The engine is mounted in the test app under '/preservation'. Is
    # there any way to test routes relative to the mount point?
    it 'routes to search interface for preservation events' do
<<<<<<< 30507351f99d3a0f47d6cf6f27cf190ecdf18a06
      expect(get: '/events').to route_to(controller: 'preservation/events', action: 'index')
=======
      expect(get: '/events').to route_to(controller: 'preservation/events', action: 'index', section: '/preservation')
>>>>>>> Adds route for /preservation/events
    end
  end
end
