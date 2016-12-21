# Borrowed from https://github.com/projecthydra/curation_concerns/blob/d9d48/spec/factories/users.rb
# TODO: Remove the :user factory from the test app that comes from CurationConcers.
FactoryGirl.define do
  factory :user do
    sequence(:email) { |_n| "email-#{srand}@test.com" }
    password 'a password'
    password_confirmation 'a password'
    factory :admin do
      after(:build) do |user|
        def user.groups
          ['admin']
        end
      end
    end
  end
end
