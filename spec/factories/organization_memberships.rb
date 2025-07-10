FactoryBot.define do
  factory :organization_membership do
    user { nil }
    organization { nil }
    role { "MyString" }
    joined_at { "2025-07-10 17:33:36" }
  end
end
