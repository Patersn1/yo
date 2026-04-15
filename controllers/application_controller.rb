# Project name: SERVD
# Description: application for organizating volunteers and community events
# Filename: application_controller.rb
# Description: overall controller for the application. controls login and session checking to restric access
# Last modified on: 12/15

# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  before_action :configure_permitted_parameters, if: :devise_controller?

  before_action :require_role

  #   Require registered organization accounts to create an organization before they are able
  #   to navigate website.
  #   Pre-Condition: An organization user without an account
  #   Post-Condition: User placed on new organization page
  
  # Sanitizer methods created to overwrite the default devise sign up fields, git.github.com was used for reference
  # protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password,
    :password_confirmation, :user_type, :admin, :tag, :name, :school, :major, :academic_year, :interest])
    devise_parameter_sanitizer.permit(:account_update, keys: [:email, :password,
    :password_confirmation, :user_type, :admin, :tag, :name, :major, :academic_year, :interest])
  end
  

  def org_create_required
    return unless current_user.organization.nil?

    redirect_to new_organization_path, flash: { notice: 'You are required to create an organization profile first.' }
  end

  protected

  # This section permits parameters :name, :major, and :year
  ## What is the purpose of this function if there is already a configure_permitted_parameters at line 24?
  def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :major, :year, :email, :password, :notification_period])
      devise_parameter_sanitizer.permit(:account_update, keys: [:name, :major, :year, :email, :password, :current_password, :notification_period, :interest])

  end

  private
  
  # Redirect unauthorized users
  def require_role(role_name)
    unless current_user && current_user.has_role?(role_name)
      flash[:alert] = "Access denied. You lack the required permissions."
      redirect_to root_path
    end
  end
end
