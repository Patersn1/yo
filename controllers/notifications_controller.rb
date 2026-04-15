class NotificationsController < ApplicationController
  before_action :set_notification, only: [:show, :edit, :update, :destroy]

  # GET /notifications
  # GET /notifications.json
  def index

    Notification.update_for(current_user)

    if current_user.org? # user is linked to an organization
      @notifications = Notification.where(organization: current_user.organization).sort_by(&:created_at).reverse
    elsif current_user.admin? # user is an admin
      @notifications = Notification.all.sort_by(&:created_at).reverse
    else # normal user      
      # get only approved organizations that the user favorited
      @favorite_organizations = current_user.favorited_organizations
      @favorite_organizations -= Organization.where(approved: false)

      # get approved events from the user's favorite organizations
      @opportunities = []
      @favorite_organizations.each do |organization|
        @opportunities += Opportunity.where(organization: organization, approved: true)
      end

      # remove duplicates to get unique array
      @opportunities += current_user.favorited_opportunities
      @opportunities = @opportunities.uniq

      # get notifications linked to the events from the array above
      @notifications = []
      @opportunities.each do |opportunity|
        @notifications += Notification.where(opportunity: opportunity)
      end
      
      # get notifications linked to the user's favorite organizations
      @favorite_organizations.each do |organization|
        @notifications += Notification.where(organization: organization, opportunity: nil)
      end
      
      @notifications = @notifications.sort_by(&:created_at).reverse.uniq
    end
  end

  # GET /notifications/1
  # GET /notifications/1.json
  def show
  end

  # GET /notifications/new
  def new
    @notification = Notification.new
  end

  # GET /notifications/1/edit
  def edit
  end

  # POST /notifications
  # POST /notifications.json
  def create
    p = notification_params
    p['organization'] = current_user.organization
    @notification = Notification.new(p)

    respond_to do |format|
      if @notification.save
        format.html { redirect_to @notification, notice: 'Notification was successfully created.' }
        format.json { render :show, status: :created, location: @notification }
      else
        format.html { render :new }
        format.json { render json: @notification.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /notifications/1
  # PATCH/PUT /notifications/1.json
  def update
    respond_to do |format|
      if @notification.update(notification_params)
        format.html { redirect_to @notification, notice: 'Notification was successfully updated.' }
        format.json { render :show, status: :ok, location: @notification }
      else
        format.html { render :edit }
        format.json { render json: @notification.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /notifications/1
  # DELETE /notifications/1.json
  def destroy
    @notification.destroy
    respond_to do |format|
      format.html { redirect_to notifications_url, notice: 'Notification was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_notification
      @notification = Notification.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def notification_params
      params.require(:notification).permit(:at, :name, :message, :user_id)
    end
end
