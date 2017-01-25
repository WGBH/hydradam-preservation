FactoryGirl.define do
  factory :event, class: Preservation::Event do

    transient do
      premis_agent_email false
    end

    premis_event_type { [Preservation::Event.premis_event_types.sample.uri] }
    premis_event_date_time { [DateTime.now - rand(30000).hours] }
    premis_event_related_object { create(:file_set) }
    sequence(:premis_agent) { |n| [::RDF::URI.new("mailto:premis_agent_#{n}@hydradam.org")] }

    after :build do |event, evaluator|
      if evaluator.premis_agent_email
        # Do not append to :premis_agent here. If :premis_agent_email was passed in, then we want
        # to use it instead of the default sequence for:premis_agent.
        event.premis_agent = [::RDF::URI.new("mailto:#{evaluator.premis_agent_email}")]
      end
    end
  end
end
