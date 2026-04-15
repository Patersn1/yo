class NotificationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  # Reset test databases and create default user and organization
  setup do
    
    FavoriteOpportunity.all.delete_all
    Opportunity.all.delete_all
    Organization.all.delete_all
    Notification.all.delete_all
    User.all.delete_all

    @now = Time.now

    @testing_user = User.create!(email: 'student@example.com', password: 'password', password_confirmation: 'password')
    @testing_org = Organization.create!(user: @testing_user, name: 'example1.org', email: @testing_user.email, phone_no: '8001112222', address: '1 Road Street', city: 'Ewing', state: 'NJ', zip_code: '08658', description: 'This is an org', approved: true)
  end

  # Test upcoming event notifications being created when an event is created within the correct date range
  test "should create upcoming notification" do

    testing_event1 = Opportunity.create!(
        organization: @testing_user.organization,
        name: 'Testing Event1',
        address: '1 Street Road',
        city: 'Ewing', state: 'NJ', 
        zip_code: '08658',
        transportation: false,
        description: 'This is an event for tests.',
        frequency: 'daily',
        email: 'org@test.com',
        on_date: @now,
        start_time: @now,
        end_time: @now + 1.hour,
        approved: true
    )

    testing_event2 = Opportunity.create!(
        organization: @testing_user.organization,
        name: 'Testing Event2',
        address: '1 Street Road',
        city: 'Ewing', state: 'NJ', 
        zip_code: '08658',
        transportation: false,
        description: 'This is an event for tests.',
        frequency: 'daily',
        email: 'org@test.com',
        on_date: @now + @testing_user.notification_period.days,
        start_time: @now,
        end_time: @now,
        approved: true
    )

    FavoriteOpportunity.create!(
        opportunity: testing_event1,
        user: @testing_user
    )

    FavoriteOpportunity.create!(
        opportunity: testing_event2,
        user: @testing_user
    )

    Notification.update_for(@testing_user)

    assert Notification.exists?(["opportunity_id = ? AND notification_type = ?",
        testing_event1.id,
        Notification.notification_types[:upcoming_opportunity]])

    assert Notification.exists?(["opportunity_id = ? AND notification_type = ?",
        testing_event2.id,
        Notification.notification_types[:upcoming_opportunity]])
  end

  # Test upcoming event notifications being created when an event is edited to be within the correct date range
  test "should create upcoming notification on edit" do

    testing_event1 = Opportunity.create!(
        organization: @testing_user.organization,
        name: 'Testing Event1',
        address: '1 Street Road',
        city: 'Ewing', state: 'NJ', 
        zip_code: '08658',
        transportation: false,
        description: 'This is an event for tests.',
        frequency: 'daily',
        email: 'org@test.com',
        on_date: @now - 1.day,
        start_time: @now,
        end_time: @now + 1.hour,
        approved: true
    )

    FavoriteOpportunity.create!(
        opportunity: testing_event1,
        user: @testing_user
    )

    Notification.update_for(@testing_user)

    assert_not Notification.exists?(["opportunity_id = ? AND notification_type = ?",
        testing_event1.id,
        Notification.notification_types[:upcoming_opportunity]])

    Opportunity.where(id: testing_event1.id).update(:on_date => @now)

    Notification.update_for(@testing_user)

    assert Notification.exists?(["opportunity_id = ? AND notification_type = ?",
        testing_event1.id,
        Notification.notification_types[:upcoming_opportunity]])

  end

  # Test upcoming event notifications not being created when an event is not within the correct date range
  test "should not create upcoming notification" do

    testing_event1 = Opportunity.create!(
        organization: @testing_user.organization,
        name: 'Testing Event1',
        address: '1 Street Road',
        city: 'Ewing', state: 'NJ', 
        zip_code: '08658',
        transportation: false,
        description: 'This is an event for tests.',
        frequency: 'daily',
        email: 'org@test.com',
        on_date: @now - 1.day,
        start_time: @now,
        end_time: @now,
        approved: true
    )

    testing_event2 = Opportunity.create!(
        organization: @testing_user.organization,
        name: 'Testing Event2',
        address: '1 Street Road',
        city: 'Ewing', state: 'NJ', 
        zip_code: '08658',
        transportation: false,
        description: 'This is an event for tests.',
        frequency: 'daily',
        email: 'org@test.com',
        on_date: @now + @testing_user.notification_period.days + 1.day,
        start_time: @now,
        end_time: @now,
        approved: true
    )

    FavoriteOpportunity.create!(
        opportunity: testing_event1,
        user: @testing_user
    )

    FavoriteOpportunity.create!(
        opportunity: testing_event2,
        user: @testing_user
    )

    Notification.update_for(@testing_user)

    assert_not Notification.exists?(["opportunity_id = ? AND notification_type = ?",
        testing_event1.id,
        Notification.notification_types[:upcoming_opportunity]])

    assert_not Notification.exists?(["opportunity_id = ? AND notification_type = ?",
        testing_event2.id,
        Notification.notification_types[:upcoming_opportunity]])
  end

  # Test upcoming event notifications being deleted when an event is not within the correct date range
  test "should delete invalid upcoming notification" do

    testing_event1 = Opportunity.create!(
        organization: @testing_user.organization,
        name: 'Testing Event1',
        address: '1 Street Road',
        city: 'Ewing', state: 'NJ', 
        zip_code: '08658',
        transportation: false,
        description: 'This is an event for tests.',
        frequency: 'daily',
        email: 'org@test.com',
        on_date: @now,
        start_time: @now,
        end_time: @now,
        approved: true
    )

    testing_event2 = Opportunity.create!(
        organization: @testing_user.organization,
        name: 'Testing Event2',
        address: '1 Street Road',
        city: 'Ewing', state: 'NJ', 
        zip_code: '08658',
        transportation: false,
        description: 'This is an event for tests.',
        frequency: 'daily',
        email: 'org@test.com',
        on_date: @now + @testing_user.notification_period.days,
        start_time: @now,
        end_time: @now,
        approved: true
    )

    FavoriteOpportunity.create!(
        opportunity: testing_event1,
        user: @testing_user
    )

    FavoriteOpportunity.create!(
        opportunity: testing_event2,
        user: @testing_user
    )

    Notification.update_for(@testing_user)

    assert Notification.exists?(["opportunity_id = ? AND notification_type = ?",
        testing_event1.id,
        Notification.notification_types[:upcoming_opportunity]])

    assert Notification.exists?(["opportunity_id = ? AND notification_type = ?",
        testing_event2.id,
        Notification.notification_types[:upcoming_opportunity]])


    Opportunity.where(id: testing_event1.id).update(:on_date => @now - 1.day)
    Opportunity.where(id: testing_event2.id).update(:on_date => @now + @testing_user.notification_period.days + 1.day)

    Notification.update_for(@testing_user)

    assert_not Notification.exists?(["opportunity_id = ? AND notification_type = ?",
        testing_event1.id,
        Notification.notification_types[:upcoming_opportunity]])

    assert_not Notification.exists?(["opportunity_id = ? AND notification_type = ?",
        testing_event2.id,
        Notification.notification_types[:upcoming_opportunity]])
  end

end
