FactoryBot.define do
  factory :parental_consent do
    user { nil }
    parent_name { "MyString" }
    parent_email { "MyString" }
    consent_given_at { "2025-07-10 17:34:30" }
  end
end
