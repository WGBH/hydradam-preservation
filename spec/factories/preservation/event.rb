FactoryGirl.define do
  factory :event, class: Preservation::Event do
    premis_event_type { [Preservation::Event.premis_event_types.values.sample] }
  end
end
