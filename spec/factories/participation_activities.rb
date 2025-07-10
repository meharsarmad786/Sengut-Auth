FactoryBot.define do
  factory :participation_activity do
    user { nil }
    organization { nil }
    activity_type { "MyString" }
    activity_data { "MyText" }
    created_at { "2025-07-10 17:34:46" }
  end
end
