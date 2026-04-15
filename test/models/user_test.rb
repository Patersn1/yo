# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do 
    @user = User.create!(email: "test@example.com", password: "password123")
    @volunteer_role = Role.create!(name: "Volunteer")
    @admin_role = Role.create!(name: "Admin")
  end

  test 'should be valid' do
    assert @user.valid?
  end

  test 'name should be present' do
    @user.name = '     '
    assert_not @user.valid?
  end

  test 'email should be present' do
    @user.email = '     '
    assert_not @user.valid?
  end

  test "assign_role adds a role to the RolesUsers join table" do
    @user.assign_role(@admin_role)
    @user.remove_role(@admin_role)
    assert_not @user.has_role?("Admin"), "Expected Admin role to be removed from user"
  end
end
