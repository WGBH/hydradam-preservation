module Preservation
  class EventIndexer < ActiveFedora::IndexingService
    def generate_solr_document
      super.tap do |solr_doc|
        # TODO: Some of the conditionals checking for existence of properties
        # may be removed after require those fields with validations on the
        # model.

        unless object.premis_event_type.empty?
          # Index the PREMIS event type.
          # NOTE: the value we index is only the last URI segment, which is a
          # 3-letter abbreviation.
          Solrizer.set_field(solr_doc,
                             'premis_event_type',
                             shortened_field_val = URI(object.premis_event_type.first.id).path.split('/').last,
                             :symbol)
        end

        unless object.premis_agent.empty?
          # Index the PREMIS agent, under the assumption that is a mailto: URI.
          # NOTE: The value we index is only the amil address, without the "mailto:" part.
          Solrizer.set_field(solr_doc,
                             'premis_agent',
                             object.premis_agent.first.id.sub(/^mailto:/, ''),
                             :symbol)
        end


        # If the PreservationEvent's agent is found in the db,
        # then index that user's full name as well.
        # TODO: Not sure if this is a good idea.
        #   How much metadata about the agent should we index for PreservationEvents?
        # if object.premis_agent_db_user
        #   Solrizer.set_field(solr_doc,
        #                      'premis_agent_full_name',
        #                      object.premis_agent_db_user.first.id,
        #                      :stored_searchable)
        # end

        unless object.premis_event_date_time.empty?
          # Index the PREMIS event date time as a date.
          Solrizer.set_field(solr_doc,
                             'premis_event_date_time',
                             object.premis_event_date_time.first,
                             :stored_searchable)

          # Index the PREMIS event date time as an integer, for range queries.
          Solrizer.set_field(solr_doc,
                             'premis_event_date_time_integer',
                             object.premis_event_date_time.first.strftime('%Y%m%d').to_i,
                             Solrizer::Descriptor.new(:long, :stored, :indexed))
        end
      end
    end
  end
end