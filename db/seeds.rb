# Project name: SERVD
# Description: application for organizating volunteers and community events
# Filename: seeds.rb
# Description: provides data to be used by the application
# Last modified on: 11/09

# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Skip email callbacks during seeding
Opportunity.skip_callback(:create, :after, :new_opportunity)

['Volunteer','Organization', 'Staff', 'Admin'].each do |role|
  Role.find_or_create_by(name: role)
end

# FIXME: only for dev modes
# added new fields and values for student account
admin = User.find_or_create_by!(email: 'admin@example.com') do |u|
  u.password = 'pas$word26'
  u.password_confirmation = 'pas$word26'
  u.admin = true
end
student = User.find_or_create_by!(email: 'student@example.com') do |u|
  u.password = 'pas$word26'
  u.password_confirmation = 'pas$word26'
  u.academic_year = 'Junior'
  u.major = 'Computer Science'
  u.interest = 'Art'
  u.name = 'Nicole'
  u.school = 'TCNJ'
end
org_user1 = User.find_or_create_by!(email: 'organizer1@example.com') do |u|
  u.organization_id = 1
  u.password = 'pas$word26'
  u.password_confirmation = 'pas$word26'
end
org_user2 = User.find_or_create_by!(email: 'organizer2@example.com') do |u|
  u.organization_id = 2
  u.password = 'pas$word26'
  u.password_confirmation = 'pas$word26'
end
org_user3 = User.find_or_create_by!(email: 'organizer3@example.com') do |u|
  u.organization_id = 3
  u.password = 'pas$word26'
  u.password_confirmation = 'pas$word26'
end
org_user4 = User.find_or_create_by!(email: 'organizer4@example.com') do |u|
  u.organization_id = 4
  u.password = 'pas$word26'
  u.password_confirmation = 'pas$word26'
end
org_user5 = User.find_or_create_by!(email: 'organizer5@example.com') do |u|
  u.organization_id = 5
  u.password = 'pas$word26'
  u.password_confirmation = 'pas$word26'
end

org1 = Organization.find_or_create_by!(email: org_user1.email) do |o|
  o.user = org_user1
  o.name = 'example1.org'
  o.phone_no = '8001112222'
  o.address = '1 Road Street'
  o.city = 'Ewing'
  o.state = 'NJ'
  o.zip_code = '08658'
  o.description = 'This is an org that has been approved and has events 1, 2, and 3.'
  o.approved = true
end
org2 = Organization.find_or_create_by!(email: org_user2.email) do |o|
  o.user = org_user2
  o.name = 'example2.org'
  o.phone_no = '8001113333'
  o.address = '2 Road Street'
  o.city = 'Ewing'
  o.state = 'NJ'
  o.zip_code = '08658'
  o.description = 'This is an org that has been approved and has events 4, 5, and 6.'
  o.approved = true
end
org3 = Organization.find_or_create_by!(email: org_user3.email) do |o|
  o.user = org_user3
  o.name = 'example3.org'
  o.phone_no = '8001114444'
  o.address = '3 Road Street'
  o.city = 'Ewing'
  o.state = 'NJ'
  o.zip_code = '08658'
  o.description = 'This is an org that has been approved and has NO events.'
  o.approved = true
end
org4 = Organization.find_or_create_by!(email: org_user4.email) do |o|
  o.user = org_user4
  o.name = 'example4.org'
  o.phone_no = '8001115555'
  o.address = '4 Road Street'
  o.city = 'Ewing'
  o.state = 'NJ'
  o.zip_code = '08658'
  o.description = 'This is an org that has NOT been approved and currently as events 7 and 8.'
end
org5 = Organization.find_or_create_by!(email: org_user5.email) do |o|
  o.user = org_user5
  o.name = 'example5.org'
  o.phone_no = '8001116666'
  o.address = '5 Road Street'
  o.city = 'Ewing'
  o.state = 'NJ'
  o.zip_code = '08658'
  o.description = 'This is an org that has NOT been approved and currently has NO events.'
end
# org5 = Organization.create!(user: test_org, name: 'testOrg', email: testOrg.email, phone_no: '8001002000', address: '6 Road Street', city: 'Ewing', state: 'NJ', zip_code: '08658', description: 'This is an org that has been approved and currently has NO events.', approved: true)

opp1 = Opportunity.find_or_create_by!(name: 'Event 1', organization: org1) do |o|
  o.address = '1 Street Road'
  o.city = 'Ewing'
  o.state = 'NJ'
  o.zip_code = '08658'
  o.transportation = false
  o.description = 'This is event 1.'
  o.frequency = 'daily'
  o.email = 'org@test.com'
  o.on_date = '2019-06-27'
  o.start_time = '04:22:00'
  o.end_time = '06:39:00'
  o.approved = true
end
opp2 = Opportunity.find_or_create_by!(name: 'Event 2', organization: org1) do |o|
  o.address = '2 Street Road'
  o.city = 'Trenton'
  o.state = 'NJ'
  o.zip_code = '08657'
  o.transportation = false
  o.description = 'This is event 2.'
  o.frequency = 'weekly'
  o.email = 'org@test.com'
  o.on_date = '2025-07-16'
  o.start_time = '04:22:00'
  o.end_time = '06:07:00'
  o.approved = true
end
opp3 = Opportunity.find_or_create_by!(name: 'Event 3', organization: org1) do |o|
  o.address = '3 Street Road'
  o.city = 'Pennington'
  o.state = 'NJ'
  o.zip_code = '08656'
  o.transportation = true
  o.description = 'This is event 3.'
  o.frequency = 'bi-weekly'
  o.email = 'org@test.com'
  o.on_date = '2025-08-22'
  o.start_time = '04:22:00'
  o.end_time = '06:07:00'
end
opp4 = Opportunity.find_or_create_by!(name: 'Event 4', organization: org2) do |o|
  o.address = '4 Street Road'
  o.city = 'Hamilton'
  o.state = 'NJ'
  o.zip_code = '08655'
  o.transportation = true
  o.description = 'This is event 4.'
  o.frequency = 'monthly'
  o.email = 'org@test.com'
  o.on_date = '2019-09-19'
  o.start_time = '04:22'
  o.end_time = '06:07'
  o.approved = true
end
opp5 = Opportunity.find_or_create_by!(name: 'Event 5', organization: org2) do |o|
  o.address = '5 Street Road'
  o.city = 'Lawrence Township'
  o.state = 'NJ'
  o.zip_code = '08654'
  o.transportation = true
  o.description = 'This is event 5.'
  o.frequency = 'bi-monthly'
  o.email = 'org@test.com'
  o.on_date = '2020-06-27'
  o.start_time = '04:22:00'
  o.end_time = '06:39:00'
  o.approved = true
end
opp6 = Opportunity.find_or_create_by!(name: 'Event 6', organization: org2) do |o|
  o.address = '6 Street Road'
  o.city = 'Princeton'
  o.state = 'NJ'
  o.zip_code = '08653'
  o.transportation = false
  o.description = 'This is event 6.'
  o.frequency = 'semi-annually'
  o.email = 'org@test.com'
  o.on_date = '2020-07-16'
  o.start_time = '04:22:00'
  o.end_time = '06:07:00'
  o.approved = true
end
opp7 = Opportunity.find_or_create_by!(name: 'Event 7', organization: org4) do |o|
  o.address = '7 Street Road'
  o.city = 'New Egypt'
  o.state = 'NJ'
  o.zip_code = '08652'
  o.transportation = true
  o.description = 'This is event 7.'
  o.frequency = 'annually'
  o.email = 'org@test.com'
  o.on_date = '2020-08-22'
  o.start_time = '04:22:00'
  o.end_time = '06:07:00'
end
opp8 = Opportunity.find_or_create_by!(name: 'Event 8', organization: org4) do |o|
  o.address = '8 Street Road'
  o.city = 'Moorestown'
  o.state = 'NJ'
  o.zip_code = '08651'
  o.transportation = false
  o.description = 'This is event 8.'
  o.frequency = 'one-time'
  o.email = 'org@test.com'
  o.on_date = '2019-09-19'
  o.start_time = '04:22'
  o.end_time = '06:07:00'
  o.approved = true
end

Tag.find_or_create_by!(name: 'tag1') { |t| t.approved = true }
Tag.find_or_create_by!(name: 'tag2') { |t| t.approved = true }
Tag.find_or_create_by!(name: 'tag3') { |t| t.approved = true }
Tag.find_or_create_by!(name: 'tag4') { |t| t.approved = true }
Tag.find_or_create_by!(name: 'tag5') { |t| t.approved = true }
Tag.find_or_create_by!(name: 'tag6') { |t| t.approved = true }
Tag.find_or_create_by!(name: 'tag7') { |t| t.approved = true }
Tag.find_or_create_by!(name: 'tag8') { |t| t.approved = true }
Tag.find_or_create_by!(name: 'tag9') { |t| t.approved = true }

Notification.find_or_create_by!(name: "New Event: " + opp1.name, organization: org1) do |n|
  n.created_at = '21 May 2019 14:00:00 -0400'
  n.opportunity = opp1
  n.message = org1.name + " has created a new event!"
end
Notification.find_or_create_by!(name: "New Event: " + opp2.name, organization: org1) do |n|
  n.created_at = '22 May 2019 14:00:00 -0400'
  n.opportunity = opp2
  n.message = org1.name + " has created a new event!"
end
Notification.find_or_create_by!(name: "New Event: " + opp3.name, organization: org1) do |n|
  n.created_at = '23 May 2019 14:00:00 -0400'
  n.opportunity = opp3
  n.message = org1.name + " has created a new event!"
end
Notification.find_or_create_by!(name: "New Event: " + opp4.name, organization: org2) do |n|
  n.created_at = '10 May 2019 14:00:00 -0400'
  n.opportunity = opp4
  n.message = org2.name + " has created a new event!"
end
Notification.find_or_create_by!(name: "New Event: " + opp5.name, organization: org2) do |n|
  n.created_at = '13 May 2019 14:00:00 -0400'
  n.opportunity = opp5
  n.message = org2.name + " has created a new event!"
end
Notification.find_or_create_by!(name: "New Event: " + opp6.name, organization: org2) do |n|
  n.created_at = '22 May 2019 13:00:00 -0400'
  n.opportunity = opp6
  n.message = org2.name + " has created a new event!"
end
Notification.find_or_create_by!(name: "New Event: " + opp7.name, organization: org4) do |n|
  n.created_at = '19 May 2019 14:00:00 -0400'
  n.opportunity = opp7
  n.message = org4.name + " has created a new event!"
end
Notification.find_or_create_by!(name: "New Event: " + opp8.name, organization: org4) do |n|
  n.created_at = '29 May 2019 14:00:00 -0400'
  n.opportunity = opp8
  n.message = org4.name + " has created a new event!"
end

# ============================================
# NEW TEST DATA - Added for demo purposes
# ============================================

# Create a new organization for community events
demo_org_user = User.find_or_create_by!(email: 'community@example.com') do |u|
  u.organization_id = 6
  u.password = 'password'
  u.password_confirmation = 'password'
end
demo_org = Organization.find_or_create_by!(email: demo_org_user.email) do |o|
  o.user = demo_org_user
  o.name = 'Community Helpers'
  o.phone_no = '6095551234'
  o.address = '100 Main Street'
  o.city = 'Ewing'
  o.state = 'NJ'
  o.zip_code = '08618'
  o.description = 'A community organization dedicated to helping local residents through volunteer events.'
  o.approved = true
end

# Create upcoming events with future dates
upcoming_event1 = Opportunity.find_or_create_by!(name: 'Spring Food Drive', organization: demo_org) do |o|
  o.address = '200 Community Center Dr'
  o.city = 'Ewing'
  o.state = 'NJ'
  o.zip_code = '08618'
  o.transportation = true
  o.description = 'Help collect and distribute food to families in need. All volunteers welcome.'
  o.frequency = 'weekly'
  o.email = 'events@community.org'
  o.on_date = '2026-03-15'
  o.start_time = '09:00:00'
  o.end_time = '14:00:00'
  o.approved = true
end

upcoming_event2 = Opportunity.find_or_create_by!(name: 'Park Cleanup Day', organization: demo_org) do |o|
  o.address = '50 Green Park Ave'
  o.city = 'Ewing'
  o.state = 'NJ'
  o.zip_code = '08618'
  o.transportation = false
  o.description = 'Join us for our annual park cleanup. Gloves and bags provided.'
  o.frequency = 'one-time'
  o.email = 'events@community.org'
  o.on_date = '2026-03-01'
  o.start_time = '10:00:00'
  o.end_time = '13:00:00'
  o.approved = true
end

upcoming_event3 = Opportunity.find_or_create_by!(name: 'Senior Center Visit', organization: demo_org) do |o|
  o.address = '75 Elder Care Lane'
  o.city = 'Trenton'
  o.state = 'NJ'
  o.zip_code = '08608'
  o.transportation = true
  o.description = 'Spend time with seniors at the local care center. Activities include games and reading.'
  o.frequency = 'bi-weekly'
  o.email = 'events@community.org'
  o.on_date = '2026-02-28'
  o.start_time = '14:00:00'
  o.end_time = '17:00:00'
  o.approved = true
end

upcoming_event4 = Opportunity.find_or_create_by!(name: 'Tutoring Session', organization: org1) do |o|
  o.address = '1 Road Street'
  o.city = 'Ewing'
  o.state = 'NJ'
  o.zip_code = '08658'
  o.transportation = false
  o.description = 'Help local students with homework and test preparation.'
  o.frequency = 'weekly'
  o.email = 'org@test.com'
  o.on_date = '2026-02-25'
  o.start_time = '15:00:00'
  o.end_time = '18:00:00'
  o.approved = true
end

# Add favorite opportunities for the student user
FavoriteOpportunity.find_or_create_by!(user: student, opportunity: upcoming_event1)
FavoriteOpportunity.find_or_create_by!(user: student, opportunity: upcoming_event2)
FavoriteOpportunity.find_or_create_by!(user: student, opportunity: upcoming_event4)

# Add favorite organization for the student
FavoriteOrganization.find_or_create_by!(user: student, organization: demo_org)
FavoriteOrganization.find_or_create_by!(user: student, organization: org1)

# Create recent notifications that will be visible
Notification.find_or_create_by!(name: "New Event: Spring Food Drive", organization: demo_org) do |n|
  n.created_at = Time.now - 1.hour
  n.opportunity = upcoming_event1
  n.message = "Community Helpers has created a new event! Join us for the Spring Food Drive."
  n.notification_type = 0
end

Notification.find_or_create_by!(name: "New Event: Park Cleanup Day", organization: demo_org) do |n|
  n.created_at = Time.now - 2.hours
  n.opportunity = upcoming_event2
  n.message = "Community Helpers has created a new event! Help us clean up the local park."
  n.notification_type = 0
end

Notification.find_or_create_by!(name: "Reminder: Senior Center Visit", organization: demo_org) do |n|
  n.created_at = Time.now - 30.minutes
  n.opportunity = upcoming_event3
  n.message = "Don't forget - Senior Center Visit is coming up on February 28th!"
  n.notification_type = 2
end

Notification.find_or_create_by!(name: "New Event: Tutoring Session", organization: org1) do |n|
  n.created_at = Time.now - 3.hours
  n.opportunity = upcoming_event4
  n.message = "example1.org is looking for volunteer tutors! Sign up now."
  n.notification_type = 0
end

Notification.find_or_create_by!(name: "Event Updated: Event 2", organization: org2) do |n|
  n.created_at = Time.now - 6.hours
  n.opportunity = opp2
  n.message = "example2.org has updated the details for Event 2."
  n.notification_type = 1
end

puts "Seed data loaded successfully!"
puts "Demo accounts:"
puts "  Admin: admin@example.com / pas$word26"
puts "  Student: student@example.com / pas$word26"
puts "  Org user: community@example.com / pas$word26"
