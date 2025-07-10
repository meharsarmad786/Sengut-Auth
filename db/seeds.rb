# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create Age Groups
puts "Creating age groups..."

age_groups = [
  {
    name: "Children (6-12)",
    min_age: 6,
    max_age: 12,
    description: "Young children require parental supervision and consent for all activities. Content is filtered for age-appropriate material."
  },
  {
    name: "Teenagers (13-17)",
    min_age: 13,
    max_age: 17,
    description: "Teenagers can participate in most activities but require parental consent. Access to teen-appropriate content."
  },
  {
    name: "Young Adults (18-25)",
    min_age: 18,
    max_age: 25,
    description: "Full access to all content and activities. Can create and manage organizations."
  },
  {
    name: "Adults (26-64)",
    min_age: 26,
    max_age: 64,
    description: "Full access to all content and activities. Ideal for professional and community organizations."
  },
  {
    name: "Seniors (65+)",
    min_age: 65,
    max_age: 120,
    description: "Full access with optional assistance features. Perfect for senior community groups."
  }
]

age_groups.each do |age_group_data|
  AgeGroup.find_or_create_by(name: age_group_data[:name]) do |age_group|
    age_group.min_age = age_group_data[:min_age]
    age_group.max_age = age_group_data[:max_age]
    age_group.description = age_group_data[:description]
  end
end

puts "Created #{AgeGroup.count} age groups"

# Create Organizations
puts "Creating organizations..."

organizations = [
  {
    name: "Tech Innovation Club",
    description: "A community for technology enthusiasts to share knowledge, collaborate on projects, and discuss the latest trends in tech.",
    active: true
  },
  {
    name: "Green Earth Initiative",
    description: "Environmental organization focused on sustainability, conservation, and promoting eco-friendly practices in our community.",
    active: true
  },
  {
    name: "Youth Leadership Program",
    description: "Empowering young people through leadership development, mentorship, and community service opportunities.",
    active: true
  },
  {
    name: "Senior Community Center",
    description: "A place for seniors to connect, participate in activities, and access resources for healthy aging.",
    active: true
  },
  {
    name: "Creative Arts Collective",
    description: "Bringing together artists, musicians, writers, and creative minds to collaborate and showcase their work.",
    active: true
  }
]

organizations.each do |org_data|
  Organization.find_or_create_by(name: org_data[:name]) do |org|
    org.description = org_data[:description]
    org.active = org_data[:active]
  end
end

puts "Created #{Organization.count} organizations"

# Create Sample Users
puts "Creating sample users..."

# Admin User
admin_user = User.find_or_create_by(email: "admin@sengut.com") do |user|
  user.first_name = "Admin"
  user.last_name = "User"
  user.date_of_birth = 30.years.ago.to_date
  user.phone = "+1234567890"
  user.password = "password123"
  user.password_confirmation = "password123"
end

# Adult User
adult_user = User.find_or_create_by(email: "adult@sengut.com") do |user|
  user.first_name = "John"
  user.last_name = "Doe"
  user.date_of_birth = 28.years.ago.to_date
  user.phone = "+1234567891"
  user.password = "password123"
  user.password_confirmation = "password123"
end

# Teen User
teen_user = User.find_or_create_by(email: "teen@sengut.com") do |user|
  user.first_name = "Jane"
  user.last_name = "Smith"
  user.date_of_birth = 16.years.ago.to_date
  user.phone = "+1234567892"
  user.password = "password123"
  user.password_confirmation = "password123"
end

# Create parental consent for teen user
if teen_user.persisted? && teen_user.minor? && !teen_user.parental_consent
  ParentalConsent.create!(
    user: teen_user,
    parent_name: "Mary Smith",
    parent_email: "mary.smith@email.com",
    consent_given_at: 1.month.ago
  )
end

# Child User
child_user = User.find_or_create_by(email: "child@sengut.com") do |user|
  user.first_name = "Tommy"
  user.last_name = "Johnson"
  user.date_of_birth = 10.years.ago.to_date
  user.phone = "+1234567893"
  user.password = "password123"
  user.password_confirmation = "password123"
end

# Create parental consent for child user
if child_user.persisted? && child_user.minor? && !child_user.parental_consent
  ParentalConsent.create!(
    user: child_user,
    parent_name: "Robert Johnson",
    parent_email: "robert.johnson@email.com",
    consent_given_at: 2.weeks.ago
  )
end

# Senior User
senior_user = User.find_or_create_by(email: "senior@sengut.com") do |user|
  user.first_name = "Margaret"
  user.last_name = "Wilson"
  user.date_of_birth = 68.years.ago.to_date
  user.phone = "+1234567894"
  user.password = "password123"
  user.password_confirmation = "password123"
end

puts "Created #{User.count} users"

# Create Organization Memberships
puts "Creating organization memberships..."

# Admin user as admin of all organizations
Organization.all.each do |org|
  unless admin_user.member_of?(org)
    org.add_member(admin_user, 'admin')
  end
end

# Adult user as member of tech and green organizations
tech_org = Organization.find_by(name: "Tech Innovation Club")
green_org = Organization.find_by(name: "Green Earth Initiative")

[tech_org, green_org].compact.each do |org|
  unless adult_user.member_of?(org)
    org.add_member(adult_user, 'member')
  end
end

# Teen user as member of youth organization (with parental consent)
youth_org = Organization.find_by(name: "Youth Leadership Program")
if youth_org && teen_user.can_participate_without_consent? && !teen_user.member_of?(youth_org)
  youth_org.add_member(teen_user, 'member')
end

# Child user as member of youth organization (with parental consent)
if youth_org && child_user.can_participate_without_consent? && !child_user.member_of?(youth_org)
  youth_org.add_member(child_user, 'member')
end

# Senior user as member of senior center
senior_org = Organization.find_by(name: "Senior Community Center")
if senior_org && !senior_user.member_of?(senior_org)
  senior_org.add_member(senior_user, 'moderator')
end

puts "Created organization memberships"

# Create Sample Participation Activities
puts "Creating sample participation activities..."

# Create some sample activities for users
User.all.each do |user|
  user.organizations.each do |org|
    # Login activities
    3.times do |i|
      ParticipationActivity.create!(
        user: user,
        organization: org,
        activity_type: 'login',
        activity_data: {
          ip_address: "192.168.1.#{rand(1..255)}",
          user_agent: "Mozilla/5.0 (Sample Browser)",
          timestamp: (i + 1).days.ago
        }.to_json
      )
    end

    # Join organization activity
    ParticipationActivity.create!(
      user: user,
      organization: org,
      activity_type: 'join_organization',
      activity_data: {
        joined_at: rand(1..30).days.ago,
        role: user.organization_role(org)
      }.to_json
    )
  end
end

puts "Created #{ParticipationActivity.count} participation activities"

puts "\n=== SEED DATA SUMMARY ==="
puts "Age Groups: #{AgeGroup.count}"
puts "Organizations: #{Organization.count}"
puts "Users: #{User.count}"
puts "  - Adults: #{User.adults.count}"
puts "  - Minors: #{User.minors.count}"
puts "  - With Parental Consent: #{User.joins(:parental_consent).count}"
puts "Organization Memberships: #{OrganizationMembership.count}"
puts "Participation Activities: #{ParticipationActivity.count}"
puts "Parental Consents: #{ParentalConsent.count}"

puts "\n=== SAMPLE LOGIN CREDENTIALS ==="
puts "Admin User: admin@sengut.com / password123"
puts "Adult User: adult@sengut.com / password123"
puts "Teen User: teen@sengut.com / password123 (with parental consent)"
puts "Child User: child@sengut.com / password123 (with parental consent)"
puts "Senior User: senior@sengut.com / password123"

puts "\nSeeding completed successfully!"
