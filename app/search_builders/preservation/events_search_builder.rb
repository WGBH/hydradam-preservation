module Preservation
  class EventsSearchBuilder < Blacklight::SearchBuilder
    include Blacklight::Solr::SearchBuilderBehavior

    self.default_processor_chain += [:only_models_for_preservation_events]
    def only_models_for_preservation_events(solr_params)
      solr_params[:fq] ||= []
      solr_params[:fq] << "{!terms f=has_model_ssim}Preservation::Event"
    end
  end
end
