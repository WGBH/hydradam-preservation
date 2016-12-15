FactoryGirl.define do
  factory :event, class: Preservation::Event do
    premis_event_type { [Preservation::Event.premis_event_types.values.sample] }
    premis_event_date_time { [DateTime.now - rand(30000).hours] }
    sequence(:premis_agent) { |n| [::RDF::URI.new("mailto:premis_agent_#{n}@hydradam.org")] }
  end
end
