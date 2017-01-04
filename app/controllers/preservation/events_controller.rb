module Preservation
  class EventsController < ActionController::Base
    include Blacklight::Controller
    include Hydra::Controller::ControllerBehavior
    include Hydra::Catalog

    # TODO: WTF? Not adding these helpers causes `undefined variable or
    # method` errors during rendering. These missing methods are defined in
    # modules that are included within these helpers. But tracking it down was
    # a pita, because I had to first go find where the methods were being
    # defined within the Blacklight gem. Then I had to figure out why the
    # modules weren't getting included. Then I had to figure out how to
    # include them.
    helper CatalogHelper
    helper ComponentHelper
    helper LayoutHelper
    # Override CurationConcerns::UrlHelper#url_for_document
    helper_method :url_for_document
    helper_method :display_premis_agent
    helper_method :display_premis_event_date_time
    helper_method :display_related_file

    # Adds CurationConcerns behaviors to the application controller.
    include CurationConcerns::ApplicationControllerBehavior
    include CurationConcerns::ThemedLayoutController
    with_themed_layout '1_column'

    # Prevent CSRF attacks by raising an exception.
    # For APIs, you may want to use :null_session instead.
    protect_from_forgery with: :exception

    # Override rails path for the views by appending 'catalog' as a
    # place to look for views. This allows using default blacklight
    # views if you don't want to override each one.
    def _prefixes
      @_prefixes ||= super + ['catalog']
    end

    configure_blacklight do |config|

      config.search_builder_class = EventsSearchBuilder

      # Index view config
      config.index.document_presenter_class = EventIndexPresenter
      config.index.title_field = solr_name(:premis_event_type, :symbol)
      config.add_index_field solr_name(:hasEventRelatedObject, :symbol), label: "File", helper_method: :display_related_file
      config.add_index_field solr_name(:premis_event_date_time, :stored_searchable, type: :date), label: "Date", helper_method: :display_premis_event_date_time
      config.add_index_field solr_name(:premis_agent, :symbol), label: "Agent", helper_method: :display_premis_agent

      # Show view config
      config.show.document_presenter_class = EventShowPresenter
      config.add_show_field solr_name(:premis_agent, :symbol), label: "PREMIS Agent"
      config.add_show_field solr_name(:premis_event_date_time, :stored_searchable, type: :date), label: "Date"
      config.add_show_field solr_name(:hasEventRelatedObject, :symbol), label: "File", helper_method: :display_related_file

      # Remove unused actions from the show view. Enabling these breaks the
      # show view because Blacklight generates urls that don't exist. Figuring
      # out how to make them work will take more digging.
      config.show.document_actions.delete(:bookmark)
      config.show.document_actions.delete(:email)
      config.show.document_actions.delete(:sms)
      config.show.document_actions.delete(:citation)

      # Facet config
      config.add_facet_fields_to_solr_request!
      # config.add_facet_field :premis_event_date_time_ltsi, label: 'Date', range: { segments: false }
      config.add_facet_field solr_name(:premis_event_type, :symbol), label: 'Type'
    end

    # Overrides CatalogController::UrlHelper#url_for_document. It would be
    # nice to put this method in our own Preservation::UrlHelper module but I
    # couldn't get the helper to load after CurationConcerns::UrlHelper in
    # order to overwrite the #url_for_document method. NOTE: In any event,
    # this method needs to behave roughly the same way as
    # CurationCocerns::UrlHelper#url_for_document, so if that method changes
    # change this one accordingly.
    def url_for_document(doc, _options = {})
      polymorphic_path([preservation, doc])
    end

    def display_premis_agent(opts={})
      solr_doc = opts[:document]
      premis_agent_mailto_uri = solr_doc[opts[:field]]
      premis_agent_mailto_uri.first.sub(/^mailto\:/, '')
    end

    def display_premis_event_date_time(opts={})
      solr_doc = opts[:document]
      premis_event_date_time = solr_doc[opts[:field]]
      Date.parse(premis_event_date_time.to_s).strftime('%Y-%m-%d')
    end

    def display_related_file(opts={})
      # TODO: use Solrizer.solr_name instead of hardcoding dynamic suffixes.
      # TODO: Would like to use a helper method like #link_to
      # TODO: Are there URL helpers for FileSets here?
      solr_doc = opts[:document]
      "<a href='files/#{solr_doc[:hasEventRelatedObject_ssim].first}'>#{solr_doc[:related_file_title_tesim].first}</a>".html_safe
    end
  end
end
