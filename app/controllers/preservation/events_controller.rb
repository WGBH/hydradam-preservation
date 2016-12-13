module Preservation
  class EventsController < ApplicationController
    # include BlacklightRangeLimit::ControllerOverride
    include Hydra::Catalog

    # Override rails path for the views by appending 'catalog' as a
    # place to look for views. This allows using default blacklight
    # views if you don't want to override each one.
    # def _prefixes
    #   @_prefixes ||= super + ['catalog']
    # end

   # configure_blacklight do |config|
   #    config.search_builder_class = PreservationEventsSearchBuilder

   #    config.index.document_presenter_class = PreservationEventPresenter

   #    # TODO: Do not rely on dynamic suffixes here. Use Solrizer?
   #    config.index.title_field = :premis_event_type_tesim
   #    config.add_index_field :premis_event_related_object, label: "File"
   #    config.add_index_field :premis_event_date_time_ltsi, label: "Date", helper_method: :display_premis_event_date_time
   #    config.add_index_field :premis_agent_tesim, label: "Agent", helper_method: :display_premis_agent

   #    # Facet config
   #    config.add_facet_fields_to_solr_request!
   #    config.add_facet_field :premis_event_date_time_ltsi, label: 'Date', range: { segments: false }
   #    config.add_facet_field :premis_event_type_tesim, label: 'Type'
   #  end
  end
end