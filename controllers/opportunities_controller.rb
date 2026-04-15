# Project name: Assignment2
# Description: Storing approved organizations in a database.
# Filename: opportunities_controller.rb
# Description: Controller for oppportunities, complete with CRUD operations.
# Events are now rerunnable with the current date, a form of updating that
# the program recognizes when the user has come from the dashboard
# Last modified on: 11/11/2021

# frozen_string_literal: true

# Filename: opportunity_controller.rb
# Description: this file is the controller file for all of the opportunities and actions
# associated with the events page.

class OpportunitiesController < ApplicationController
  before_action :set_opportunity, only: %i[favorite edit show update destroy toggle_volunteer_status volunteers]

  # GET /opportunities
  # GET /opportunities.json

  # Function: favorite
  # Parameters:none
  # Pre-Condition: the user wants to favorite an event
  # Post-Condition: will favorite or unfavorite an event

  def favorited
    type = params[:type]

    if type == 'favorite'
      current_user.favorites << @opportunity
      redirect_to :back, notice: 'You favorited ' + @opportunity.name
    elsif type == 'unfavorite'
      current_user.favorites.delete(@opportunity)
      redirect_to :back, notice: 'Unfavorited ' + @opportunity.name
    else
      redirect_to :back, notice: 'Nothing happened.'
    end
  end

  # GET /
  # GET /.json
  # Function: index
  # Paramters: none
  # Pre-Condition: the user tries to get to the events page
  # Post-Condition: will display all of the approved events from 
  # approved organizations in the table in the view.
  def index
    @opportunities = Opportunity.all.sort_by(&:on_date)
    unless current_user.admin?
      if !params[:search].nil? || !params[:search] == ''
        @opportunities = Opportunity.search(params[:search]).order('on_date DESC')
      else
        @opportunities = Opportunity.all.order('on_date DESC')
      end
      return if current_user.nil? || current_user.tag.nil?

      @recommended_list = Opportunity.where(tag: current_user.tag) # gets all tags that are ligned up
      @recommended_list = @recommended_list.sort_by &:on_date
      @opportunities -= @recommended_list # takes the recommended events out from the
      # event list to avoid duplicates
    end
  end

  # GET /opportunities/1
  # GET /opportunities/1.json
  def show
    # Volunteer form system

    # Show the volunteer button only if we are not the organization
    @show_volunteer_button = user_signed_in? && (current_user.organization_id != @opportunity.organization_id)

    if @show_volunteer_button
      @volunteer_button_class = ["volunteer__do"]
      @has_record = @opportunity.volunteers.exists?(user: current_user)

      # if we have a record, then we should show "unvolunteer" in red; otherwise, "volunteer" in blue
      @volunteer_button_class.append(@has_record ? "volunteer__do--danger" : "volunteer__do--primary")
      @volunteer_button_text = @has_record ? "Remove from Volunteers" : "Volunteer"
    end

    # Management options (edit, send email) are visible for organization members and admins
    @show_management_options = can_show_management_options(@opportunity)
    if @show_management_options
      # only run this query if we need to!
      @volunteer_count = @opportunity.volunteers.all.size
    end
  end

  # GET /opportunities/new
  # Function: new
  # Parameters: none
  # Pre-Condition: user selects new opportunity
  # Post-Condition: will render a page for the user to create a new opportunity
  def new
    # If Rerun was selected from dashboard
    # if (request.env['HTTP_REFERER'].include?('/dashboard'))
    #   @opportunity = Opportunity.find(params[:opp_id])
    #   @opportunity.on_date = Date.current
    # else
      @opportunity = Opportunity.new
    # end
  end

  # GET /opportunities/1/edit
  # Function: edit
  # Parameters: none
  # Pre-Condition: user selects the edit button for one of the opportunities in the view
  # Post-Condition: user is taken to the edit page to alter the opportunities information
  def edit; end

  def roster
    @opportunity = Opportunity.find(params[:id])
    @opportunity_name = @opportunity.name
    @roster = @opportunity.favorited_by
  end

  # POST /opportunities
  # POST /opportunities.json
  # Function: create
  # Parameters: none
  # Pre-Condition: the user has filled out the new opportunity form and then selects create event
  # Post-Condition: the new opportunity will be added to the datatable
  def create
    p = opportunity_params
    p['email'] = current_user.email
    p['organization'] = current_user.organization
    p['state'].upcase!
    @opportunity = Opportunity.new(p)
    respond_to do |format|
      if @opportunity.save
        notification_p = {'organization' => current_user.organization, 'opportunity' => @opportunity, 'name' => "New Event: " + @opportunity.name, 'message' => current_user.organization.name + " has created a new event!"}
        @notification = Notification.new(notification_p)
        @notification.save

        format.html { redirect_to @opportunity, notice: 'Opportunity was successfully created.' }
        format.json { render :show, status: :created, location: @opportunity }
      else
        format.html { render :new }
        format.json { render json: @opportunity.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /opportunities/1
  # PATCH/PUT /opportunities/1.json
  # Function: update
  # Parameters: none
  # Pre-Condition: the user has made some changes to the edit view forms and selected the update button
  # Post-Condition: the event in the table will be updated with the new information
  def update
    respond_to do |format|
      if @opportunity.update(opportunity_params)
        if current_user.org?
          notification_p = {'organization' => current_user.organization, 'opportunity' => @opportunity, 'name' => "Event Updated: " + @opportunity.name, 'message' => current_user.organization.name + " has updated this event!"}
          @notification = Notification.new(notification_p)
          @notification.save
        else
          notification_p = {'organization' => @opportunity.organization, 'opportunity' => @opportunity, 'name' => "Event Updated: " + @opportunity.name, 'message' => "An administrator has updated this event!"}
          @notification = Notification.new(notification_p)
          @notification.save
        end
        
        format.html { redirect_to @opportunity, notice: 'Opportunity was successfully updated.' }
        format.json { render :show, status: :ok, location: @opportunity }
      else
        format.html { render :edit }
        format.json { render json: @opportunity.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /opportunities/1
  # DELETE /opportunities/1.json
  # Function: destroy
  # Parameters: none
  # Pre-Condition: the user selects on the delete button for the event in the view
  # Post-Condition: the event will be removed from the opportunity table
  def destroy
    unless current_user.admin?
      notification_p = {'organization' => current_user.organization, 'opportunity' => @opportunity, 'name' => "Event Deleted: " + @opportunity.name, 'message' => current_user.organization.name + " has deleted this event!"}
      @notification = Notification.new(notification_p)
      @notification.save
    else
      notification_p = {'organization' => @opportunity.organization, 'opportunity' => @opportunity, 'name' => "Event Deleted: " + @opportunity.name, 'message' => "An administrator has deleted this event!"}
      @notification = Notification.new(notification_p)
      @notification.save
    end

    @opportunity.destroy
    respond_to do |format|
      format.html { redirect_back fallback_location: :back, notice: 'Opportunity was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # Function: new
  # Parameters: none
  # Pre-Condition: the user selects on the add car link
  # Post-Condition: the user will be redirected to an add car page
  def add_car; end

  # Function: new
  # Parameters: none
  # Pre-Condition: the user selects on the request ride link
  # Post-Condition: the user will be redirected to a request ride page
  def request_ride; end

  # POST /opportunities/1/toggle_volunteer_status
  # Parameters: none
  # Pre-Condition: the user is not the owner of the organization, the user selects the volunteer or un-volunteer button for the event in the view
  # Post-Condition: the user will either be added or removed from the volunteer list
  def toggle_volunteer_status
    # Ensure the organization owner is not trying to volunteer
    if current_user.organization == @opportunity.organization
      respond_to do |format|
        format.html { redirect_back fallback_location: "/opportunities", notice: "You cannot volunteer for your own event." }
        format.json { head :no_content }
      end
      return
    end

    message = "An unknown error occurred."

    record = @opportunity.volunteers.where(user_id: current_user.id).first
    if record
      message = delete_volunteer_record(record)
    else
      message = create_volunteer_record(current_user, @opportunity)
    end

    respond_to do |format|
      format.html { redirect_back fallback_location: "/opportunities", notice: message }
      format.json { head :no_content }
    end
  end

  # GET /opportunities/:id/volunteers
  # Pre-Condition: The user must have management rights
  def volunteers
    @show_management_options = can_show_management_options(@opportunity)
    if @show_management_options
      @volunteers = @opportunity.volunteers.includes(:user).all
      @volunteers.load # load the data now

      @email_link = get_volunteers_email_link(@volunteers)
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_opportunity
    @opportunity = Opportunity.find(params[:id])
  end

  def approve_link_text(approvable)  
    approvable.approved? ? 'Un-approve' : 'Approve'  
  end  

  # Never trust parameters from the scary internet, only allow the white list through.
  def opportunity_params
    params.require(:opportunity).permit(:name, :approved, :address, :city, :state, :zip_code, :transportation, :description, :frequency, :email, :on_date, :start_time, :end_time, :issue_area, :primary_tag_id, :secondary_tag_id, :search)
  end

  # Volunteer forms - Delete
  def delete_volunteer_record(record)
    begin
      record.destroy
      "You are no longer volunteered for this event."
    rescue => e
      # https://stackoverflow.com/a/3486523
      logger.error e.message
      logger.error e.backtrace.join("\n")

      "An error occurred while removing your record. Please try again later."
    end
  end

  # Volunteer forms - Create
  def create_volunteer_record(user, opportunity)
    begin
      Volunteer.create(opportunity: opportunity, user: user)

      "You are now volunteered for this event."
    rescue => e
      # https://stackoverflow.com/a/3486523
      logger.error e.message
      logger.error e.backtrace.join("\n")

      "An error occurred while create your record. Please try again later."
    end
  end

  # Helper method for management options
  # Management options (edit, send email) are visible for organization members and admins
  def can_show_management_options(opportunity)
    user_signed_in? && (current_user.admin? or current_user.organization == opportunity.organization)
  end

  # get link that emails to all volunteers
  def get_volunteers_email_link(volunteers)
    emails = []
    volunteers.all.each do |volunteer|
      # emails must be URI-encoded
      # https://stackoverflow.com/a/28574383
      emails.append(ERB::Util.url_encode(volunteer.user.email))
    end

    "mailto:?bcc=" + emails.join(",")
  end
end
