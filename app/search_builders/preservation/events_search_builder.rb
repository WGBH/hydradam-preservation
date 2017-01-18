module Preservation
  class EventsSearchBuilder < Blacklight::SearchBuilder
    include Blacklight::Solr::SearchBuilderBehavior

    self.default_processor_chain += [:only_models_for_preservation_events, :apply_premis_event_date_time_range]

    def only_models_for_preservation_events(solr_params)
      solr_params[:fq] ||= []
      solr_params[:fq] << "{!terms f=has_model_ssim}Preservation::Event"
    end

    def apply_premis_event_date_time_range(solr_params)
      if solr_date_time_range
        solr_params[:fq] ||= []
        solr_params[:fq] << "premis_event_date_time_dtsim:[#{solr_date_time_range}]"
      end
      solr_params
    end

    private

    # Returns a date/time range for a Solr query for the 'after' and 'before'
    # URL params.
    def solr_date_time_range
      @solr_date_time_range ||= begin
        if solr_date_time_before || solr_date_time_after
          "#{solr_date_time_after || '*'} TO #{solr_date_time_before || '*'}"
        end
      end
    end

    # Returns the 'before' date time formatted for a Solr query.
    def solr_date_time_before
      @solr_date_time_before ||= formatted_solr_date_time(blacklight_params['before'])
    end

    # Returns the 'after' date time formatted for a Solr query.
    def solr_date_time_after
      @solr_date_time_after ||= formatted_solr_date_time(blacklight_params['after'])
    end

    # Converts an unformatted date (as passed in via URL) to a date formatted
    # for a Solr query.
    def formatted_solr_date_time(unformatted_date)
      DateTime.parse(unformatted_date.to_s).utc.strftime("%Y-%m-%dT%H:%M:%SZ")
    rescue ArgumentError => e
      nil
    end
  end
end
