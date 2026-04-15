# Added code to index to enable searching

# frozen_string_literal: true

# Idea Project
# This gives the user and orgs the ability to create ideas to:
# help the community and allow for collaboration

# organizations_controller.rb

# Filename: organizations_controller.rb
# Description: this file is the controller class for the organization view page and all associated
# interactions
class OrganizationsController < ApplicationController
  before_action :set_organization, only: [:edit, :update]
  before_action :authenticate_user!
  before_action -> {require_role('Organization Rep')}, only: [:edit, :update]

  # GET /organizations
  # GET /organizations.json
  # Function: index
  # Parameters: none
  # Pre-Condition: the user selects the organizations view from the toolbar
  # Post-Condition: a table of all organizations will be displayed to the user
  def index
    # Get list of distinct cities organizations are in
    @cities = Organization.order(:city).distinct.pluck(:city)
    # Get list of distinct states organizations are in
    @states = Organization.order(:state).distinct.pluck(:state)
    # Get list of distinct issue areas organizations cover
    @issues = Organization.order(:issue_area).distinct.pluck(:issue_area)
    if params[:keywords].present?
      # Get any keywords from search box
      @keywords = params[:keywords]
      # Use keywords to create new search term object
      organization_search_term = OrganizationSearchTerm.new(@keywords)

      # If any item chosen from dropdown list of cities
      # Then add clause to search term to find organizations in that city
      if params[:city].present?
        @city = params[:city]
        organization_search_term.where_clause << " AND city LIKE '#{@city}'"
      end

      # If any item chosen from dropdown list of states
      # Then add clause to search term to find organizations in that state
      if params[:state].present?
        @state = params[:state]
        organization_search_term.where_clause << " AND state LIKE '#{@state}'"
      end

      # If any item chosen from dropdown list of issue areas
      # Then add clause to search term to find organizations covering that issue area
      if params[:issue].present?
        @issue = params[:issue]
        organization_search_term.where_clause << " AND issue_area LIKE '#{@issue}'"
      end

      @organizations = Organization.where(
        organization_search_term.where_clause,
        organization_search_term.where_args).
        order(organization_search_term.order)
      elsif params[:city].present? && !params[:state].present? && !params[:issue].present?
        @city = params[:city]
        @organizations = Organization.where("city LIKE '#{@city}'")
      elsif params[:state].present? && !params[:city].present? && !params[:issue].present?
        @state = params[:state]
        @organizations = Organization.where("state LIKE '#{@state}'")
      elsif params[:issue].present? && !params[:state].present? && !params[:city].present?
        @issue = params[:issue]
        @organizations = Organization.where("issue_area LIKE '#{@issue}'")
      elsif params[:city].present? && params[:state].present? && !params[:issue].present?
        @city = params[:city]
        @state = params[:state]
        @organizations = Organization.where("city LIKE '#{@city}' AND state LIKE '#{@state}'")
      elsif params[:city].present? && params[:issue].present? && !params[:state].present?
        @city = params[:city]
        @issue = params[:issue]
        @organizations = Organization.where("city LIKE '#{@city}' AND issue_area LIKE '#{@issue}'")
      elsif params[:state].present? && params[:issue].present? && !params[:city].present?
        @state = params[:state]
        @issue = params[:issue]
        @organizations = Organization.where("state LIKE '#{@state}' AND issue_area LIKE '#{@issue}'")
      elsif params[:city].present? && params[:state].present? && params[:issue].present?
        @city = params[:city]
        @state = params[:state]
        @issue = params[:issue]
        @organizations = Organization.where("city LIKE '#{@city}' AND state LIKE '#{@state}' AND issue_area LIKE '#{@issue}'")
      else
      @organizations = Organization.all
      @organizations = @organizations.sort_by &:name
    end
  end

  # GET /organizations/1
  # GET /organizations/1.json
  # Function: show
  # Parameters: none
  # Pre-Condition: the user selects view for some organization in the view
  # Post-Condition: a page with all of the organizataions information will be displayed
  def show; end

  # Function: dashboard
  # Parameters: none
  # Pre-Condition: the user selects the organization/user dashboard view from the toolbar
  # Post-Condition: the user will be displayed all of the
  def dashboard
    if !current_user.organization.nil? # user is an organization
      @organizations = Organization.where(user_id: current_user.id)
      @organizations = @organizations.sort_by &:name
      @opportunities = Opportunity.where(organization_id: current_user.organization).sort_by(&:on_date).reverse
    else # normal user
      @organizations = Organization.where(approved: true).sort_by(&:name)
      @opportunities = Opportunity.all

      @volunteered_opportunities = current_user.volunteered_opportunities.sort_by(&:on_date).reverse
      @favorite_opportunities = current_user.favorited_opportunities.sort_by(&:on_date).reverse
      @favorite_organizations = current_user.favorited_organizations.sort_by(&:name).reverse
    end
  end

  # GET /organizations/new
  # Function: new
  # Parameters: none
  # Pre-Condition: the user attempts to create a new organization account
  # Post-Condition: the form for the organization information will be displayed to be filled out
  def new
    @organization = Organization.new
  end

  # GET /organizations/1/edit
  # Function: edit
  # Parameters: none
  # Pre-Condition: the user selects the edit button next to their organization
  # Post-Condition: the user will be displayed the edit page to make changes
  def edit; end

  # POST /organizations
  # POST /organizations.json
  # Function: create
  # Parameters: none
  # Pre-Condition: the user must have filled out the org form and then click the create button
  # Post-Condition: the organizations information will be  in the table to the new information
  def create
    p = organization_params
    p[:user] = current_user
    @organization = Organization.new(p)
    # @organization.approved = FALSE # this happens by default anyway and raised an error when uncommented
    respond_to do |format|
      if @organization.save
        format.html { redirect_to @organization, notice: 'Organization was successfully created.' }
        format.json { render :show, status: :created, location: @organization }
      else
        format.html { render :new }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /organizations/1
  # PATCH/PUT /organizations/1.json
  # Function: update
  # Parameters: none
  # Pre-Condition: the user must have made some changes to the edit form and hit the update button
  # Post-Condition: the organizations information will be updated in the table
  def update
    respond_to do |format|
      if @organization.update(organization_params)
        format.html { redirect_to @organization, notice: 'Organization was successfully updated.' }
        format.json { render :show, status: :ok, location: @organization }
      else
        format.html { render :edit }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /organizations/1
  # DELETE /organizations/1.json
  # Function: destroy
  # Parameters: none
  # Post-Condition: the organization will be removed from the table
  def destroy
    @organization.destroy
    respond_to do |format|
      format.html { redirect_to organizations_url, notice: 'Organization was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_organization
    @organization = Organization.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def organization_params
    params.require(:organization).permit(:email, :name, :phone_no, :address, :city, :state, :zip_code, :description, :approved, :issue_area)
  end

  def update
    # Sanitize inputs to prevent code injection
    sanitized_desc = InputSanitizer.sanitize_input(params[:organization][:description])

    # Merge sanitized description back into the organization parameters
    safe_params = organization_params.merge(description: sanitized_desc)

    if @organization.update(safe_params)
      flash[:notice] = "Organization updated succesfully."
      redirect_to @organization
    else
      flash[:alert] = "Failed to update organization. Please check the input and try again."
      render :edit, status: :unprocessable_entity
    end
  end

  private
  
  def set_organization
    # Retrieve the organization associated with the current user
    @organization = current_user.organization
  end

  def organization_params
    params.require(:organization).permit(:name, :phone_number, :address, :state, :city, :zip_code)
  end

end
