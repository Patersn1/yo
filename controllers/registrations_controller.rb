# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  def create
    super do |resource|
      if resource.persisted?
        # Extract the requested role from the registration form
        requested_role = params[:user][:account_type]

        # Prevent role manipulation
        if ['Volunteer', 'Organization Rep'].include?(requested_role)
          role = Role.find_by(name: requested_role)
          resource.assign_role(role) if role
        else
          # Default to volunteer if the input is invalid
          default_role = Role.find_by(name: 'Volunteer')
          resource.assign_role(default_role) if default_role
        end
      end
    end
  end
end