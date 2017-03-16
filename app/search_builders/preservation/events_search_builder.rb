module Preservation
  class EventsSearchBuilder < Blacklight::SearchBuilder
    include Blacklight::Solr::SearchBuilderBehavior

    self.default_processor_chain += [:only_models_for_preservation_events, :apply_premis_event_date_time_filter,
                                     :apply_premis_event_type_filter, :apply_premis_agent_filter]

    def only_models_for_preservation_events(solr_params)
      solr_params[:fq] ||= []
      solr_params[:fq] << "{!terms f=has_model_ssim}Preservation::Event"
    end

    def apply_premis_event_date_time_filter(solr_params)
      if premis_event_date_time_filter
        solr_params[:fq] ||= []
        solr_params[:fq] << premis_event_date_time_filter
      end
      solr_params
    end

    def apply_premis_event_type_filter(solr_params)
      if premis_event_type_filter
        solr_params[:fq] ||= []
        solr_params[:fq] << premis_event_type_filter
      end
      solr_params
    end

    def apply_premis_agent_filter(solr_params)
      if premis_agent_filter
        solr_params[:fq] ||= []
        solr_params[:fq] << premis_agent_filter
      end
    end

    private

    # Returns a date/time range for a Solr query for the 'after' and 'before'
    # URL params.
    def premis_event_date_time_filter
      @premis_event_date_time_filter ||= begin
        if premis_event_date_time_before || premis_event_date_time_after
          range = "#{premis_event_date_time_after || '*'} TO #{premis_event_date_time_before || '*'}"
          "premis_event_date_time_dtsim:[#{range}]"
        end
      end
    end

    # Returns the 'before' date time formatted for a Solr query.
    def premis_event_date_time_before
      @premis_event_date_time_before ||= formatted_premis_event_date_time(blacklight_params['before'])
    end

    # Returns the 'after' date time formatted for a Solr query.
    def premis_event_date_time_after
      @premis_event_date_time_after ||= formatted_premis_event_date_time(blacklight_params['after'])
    end

    # Converts an unformatted date (as passed in via URL) to a date formatted
    # for a Solr query.
    def formatted_premis_event_date_time(unformatted_date)
      DateTime.parse(unformatted_date.to_s).utc.strftime("%Y-%m-%dT%H:%M:%SZ")
    rescue ArgumentError => e
      nil
    end

    def premis_event_type_filter
      @premis_event_type_filter ||= begin
        if blacklight_params['premis_event_type']
          valid_premis_abbrs = blacklight_params['premis_event_type'] & Preservation::PremisEventType.all.map(&:abbr)
          "(#{valid_premis_abbrs.map { |abbr| "premis_event_type_ssim:#{abbr}"}.join(" OR ")})"
        end
      end
    end

    def premis_agent_filter
      @premis_agent_filter ||= begin
        if blacklight_params['agent'].present?
          # TODO: sanitize URL parameters. Do not simply trust user input.
          "premis_agent_ssim:#{blacklight_params['agent']}"
        end
      end
    end
  end
end
