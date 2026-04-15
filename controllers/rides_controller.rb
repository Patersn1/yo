# Project name: Servd Rideshare
# Description: Users will be able to either offer their car for a ride or sign up for an open seat in a ride being 
#              offered through this feature. Drivers can input which event they are driving to and how many seats 
#              they have available while riders can request a specific car to ride in. Drivers also have the ability 
#              to approve or deny anyone a ride and can update who is specifically riding in their car. 
# Filename: rides_controller.rb
# Description: This is the controller file which interacts with the database by creating, updating, and removing 
#              cars from the rides table in the database. It also contains methods such as noRepeatRiders, assignSeat
#              and setDefault to ensure the user is doing what they intend to do and provide error handling.
# Last modified on: Nov. 10, 2021

# Note: if a method does not have documentation for the functionality and design decisions, it hasn't been changed 
#       from the default controller page set up by rails when generating a controller. 

class RidesController < ApplicationController
  before_action :set_ride, only: %i[ show edit update destroy ]
  # GET /rides or /rides.json
  def index

    # will display rides if they are found with a keyword (the input that is typed in the input box)
    if params[:keywords].present?

			@keywords = params[:keywords]
			ride = Ride.new(@keywords)
			
			@rides = Ride.where(

				ride.where_clause,
				ride.where_args).
				
				order(ride.order)

		else
      # displays all rides if no keywords are typed into the input box
			@rides = Ride.all

		end

  end

  # GET /rides/1 or /rides/1.json
  def show
  end

  # GET /rides/new
  def new
    @ride = Ride.new
  end

  # GET /rides/1/edit
  # FUNCTIONALITY: If the user has not signed up for this car already, they will be assigned a seat in the car, 
  #                If the user has signed up for this car already an error message wil appear.

  # DESIGN DECISION: This method checks to make sure there are no repeat riders in order to ensure no one's 
  #                  opportunity to get a ride is taken because of someone else's error. It assigns a ride 
  #                  within the edit method as the car has already been created, only the riders need to be updated. 
  #                  It displays a message if it is found that the user has already signed up for the specific car being
  #                  modified to let the user know they have already signed up. This provides arror handling as it 
  #                  prevents the user from adding themselves and makes them aware they already have a ride to the event. 
  def edit
    if noRepeatRiders(@ride) ==true
      assignSeat(@ride)
    else
      flash.alert = "You are already assigned to this car"
    end
  end

  # FUNCTIONALITY: Checks if the person signing up for a ride has already been assigned a seat, 
  #                returns false if user has already signed up for the car and true if they have not signed up already.
  #                Checks tif the current user's email matches anyone's in the selected car currently

  # DESIGN DECISION: This method was implemented to prevent someone from signing up for a car twice, which would be a result of error. 
  #                  This will prevent someone taking the up multiple seats which will allow others to sign up for the ride as well.
  #                  Method is seperate from the edit method as it can be added to in the future more easily this way.  
  def noRepeatRiders(curride)
    @ride = curride
    if current_user.email == @ride.rider1
      return false
    elsif current_user.email == @ride.rider2
      return false
    elsif current_user.email == @ride.rider3
      return false
    elsif current_user.email == @ride.rider4
      return false
    else
      return true
    end
  end
  
  # FUNCTIONALITY: Adds a user who wants a ride to the next avaiable open seat, if the car is full it does not add the user to the car and
  #                displays a message stating the car is full. 

  # DESIGN DECISION: This method is implemented so that multiple people can sign up for one car without overiding anyone else who has 
  #                  previously signed up for the ride. It also handles errors by not signing up anyone if the car is full and displays 
  #                  an error message. Method is seperate from the edit method as it can be added to in the future more easily this way.
  def assignSeat(curride)
    @ride = curride
    if @ride.rider1 == ""
      @ride.rider1 = current_user.email
    elsif @ride.rider2 == ""
      @ride.rider2 = current_user.email
    elsif @ride.rider3 == ""
      @ride.rider3 = current_user.email
    elsif @ride.rider4 == ""
      @ride.rider4 = current_user.email
    else
      flash.alert = "this car is full"
    end
  end

  # POST /rides or /rides.json
  # FUNCTIONALITY: Creates a new instance of a ride and adds it to the database. Also sets default values for the ride based on the total
  #                number of seats. 

  # DESIGN DECISION: Sets default values because not all users will have the same amount of available seats, method creates defaults 
  #                  to prevent someone from signing up for an unavaiable spot in the future. 
  def create
    @ride = Ride.new(ride_params)
    setDefaultRiders(@ride)

    respond_to do |format|
      if @ride.save
        format.html { redirect_to @ride, notice: "Ride was successfully created." }
        format.json { render :show, status: :created, location: @ride }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @ride.errors, status: :unprocessable_entity }
      end
    end
  end

  # FUNCTIONALITY: Sets default values of the driver the the email of the current user and sets the different riders to either 
  #                blank or seat not avaiable depending on how many seats the driver has to offer. 
 
  # DESIGN DECISION: This method automatically assigns the driver's name to the current user's email to prevent someone from 
  #                  signing someone else up for drving a car. It also sets defaults for all of the riders so potential users 
  #                  know which seats are actually available and which seats are not. Method is seperate from the edit method 
  #                  as it can be added to in the future more easily this way.
  def setDefaultRiders(curride)
    @ride = curride
    @ride.driver_name = current_user.email

    if (@ride.total_seats == 3)
      @ride.rider1 = ""
      @ride.rider2 = ""
      @ride.rider3 = ""
      @ride.rider4 = "seat not available"
    

    elsif (@ride.total_seats == 2)
      @ride.rider1 = ""
      @ride.rider2 = ""
      @ride.rider3 = "seat not available"
      @ride.rider4 = "seat not available"
    

    elsif (@ride.total_seats == 1)
      @ride.rider1 = ""
      @ride.rider2 = "seat not available"
      @ride.rider3 = "seat not available"
      @ride.rider4 = "seat not available"

    else
      @ride.rider1 = ""
      @ride.rider2 = ""
      @ride.rider3 = ""
      @ride.rider4 = ""
    end
  end

  # PATCH/PUT /rides/1 or /rides/1.json
  def update
    @ride = Ride.find(params[:id])
    respond_to do |format|
      if @ride.update(ride_params)
        format.html { redirect_to @ride, notice: "Ride was successfully updated." }
        format.json { render :show, status: :ok, location: @ride }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @ride.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rides/1 or /rides/1.json
  def destroy
    @ride.destroy
    respond_to do |format|
      format.html { redirect_to rides_url, notice: "Ride was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def search 
    @query = params[:query]
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ride
      @ride = Ride.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def ride_params
      params.require(:ride).permit(:driver_name, :opportuniy_id, :total_seats, :rider1, :created_at, :updated_at, :rider2, :rider3, :rider4, :search)
    end
end
