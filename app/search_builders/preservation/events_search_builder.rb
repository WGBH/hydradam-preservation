module Preservation
  class EventsSearchBuilder < Blacklight::SearchBuilder
    include Blacklight::Solr::SearchBuilderBehavior

    self.default_processor_chain += [:only_models_for_preservation_events, :apply_premis_event_date_time_range]

    def only_models_for_preservation_events(solr_params)
      solr_params[:fq] ||= []
      solr_params[:fq] << "{!terms f=has_model_ssim}Preservation::Event"
    end

    def apply_premis_event_date_time_range(solr_params)
      solr_date_time_range(blacklight_params['after'], blacklight_params['before']).tap do |range|
        if range
          solr_params[:fq] ||= []
          solr_params[:fq] << "premis_event_date_time_dtsim:[#{range}]"
        end
      end
      solr_params
    end

    private

    def solr_date_time_range(from_date, to_date)
      solr_date_time_format = "%Y-%m-%dT%H:%M:%SZ"
      from_date = begin
        DateTime.parse(from_date.to_s).utc.strftime(solr_date_time_format)
      rescue ArgumentError
        nil
      end

      to_date = begin
        DateTime.parse(to_date.to_s).utc.strftime(solr_date_time_format)
      rescue ArgumentError
        nil
      end

      # Return formatted solr range only if either upper or lower bound are valid date times.
      "#{from_date || '*'} TO #{to_date || '*'}" if (from_date || to_date)
    end
  end
end
