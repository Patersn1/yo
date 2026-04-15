#   Class: Notification
#
#   Functions:
#     self.update_for(current_user)
#     self.try_create_upcoming_notifications(current_user, opportunities)
#     self.try_create_reoccurring_notifications(current_user, opportunities)
#     self.delete_expired(current_user)

class Notification < ApplicationRecord
  belongs_to :organization
  belongs_to :opportunity, optional: true

  # Manual enum replacement (original enum caused arity error in this environment)
  NOTIFICATION_TYPES = {
    new_opportunity: 0,
    updated_opportunity: 1,
    upcoming_opportunity: 2,
    reoccurring_opportunity: 3
  }.freeze

  # Backwards-compatible access matching previous enum interface
  def self.notification_types
    NOTIFICATION_TYPES
  end

  # scopes
  scope :new_opportunity, -> { where(notification_type: NOTIFICATION_TYPES[:new_opportunity]) }
  scope :updated_opportunity, -> { where(notification_type: NOTIFICATION_TYPES[:updated_opportunity]) }
  scope :upcoming_opportunity, -> { where(notification_type: NOTIFICATION_TYPES[:upcoming_opportunity]) }
  scope :reoccurring_opportunity, -> { where(notification_type: NOTIFICATION_TYPES[:reoccurring_opportunity]) }

  def notification_type_key
    NOTIFICATION_TYPES.key(self[:notification_type])
  end

  NOTIFICATION_TYPES.each_key do |key|
    define_method("#{key}?") { self[:notification_type] == NOTIFICATION_TYPES[key] }
  end

  # Update and manage the notifications given the current user
  # current_user: The currently logged in user
  def self.update_for(current_user)
    
    opportunities = []

    # Get the opportunities the user favorited or is associated with 

    if current_user.org? # user is linked to an organization
      opportunities = Opportunity.where(organization: current_user.organization)
    elsif current_user.admin? # user is an admin
      opportunities = Opportunity.all
    else # normal user      
      # get only approved organizations that the user favorited
      favorite_organizations = current_user.favorited_organizations
      favorite_organizations -= Organization.where(approved: false)

      # get approved events from the user's favorite organizations
      opportunities = []
      favorite_organizations.each do |organization|
        opportunities += Opportunity.where(organization: organization, approved: true)
      end

      # remove duplicates to get unique array
      opportunities += current_user.favorited_opportunities
      opportunities = opportunities.uniq
    end

    # attempt to create new notifications for the user
    try_create_upcoming_notifications(current_user, opportunities)

    # Reoccurring event notifications not currently working since Opportunity names are 
    # currently forced to be unique
    # try_create_reoccurring_notifications(current_user, opportunities)

    delete_expired(current_user)
  end

  private
  
  # Create upcoming opportunity notifications for opportunities if their date is within the next week
  # opportunities: An array of Opportunity objects to attempt to make upcoming notifications for
  def self.try_create_upcoming_notifications(current_user, opportunities)

    now = Time.now
    reminder_date = now.to_date + current_user.notification_period.days

    # Select only opportunities within the next 7 days that haven't ended yet
    upcoming_opportunities = opportunities.select{ |opportunity| 
      (opportunity.on_date == now.to_date && opportunity.end_time.strftime("%H%M%S").to_i > now.strftime("%H%M%S").to_i) \
      || (opportunity.on_date > now.to_date && opportunity.on_date <= reminder_date)
    }
    
    # Create upcoming event notifications for any that don't yet have one
    upcoming_opportunities.each do |opportunity|

      if !Notification.exists?(["opportunity_id = ? AND notification_type = ?", opportunity.id, Notification.notification_types[:upcoming_opportunity]])
        
        notification = Notification.new({
          'organization' => opportunity.organization,
          'opportunity' => opportunity,
          'name' => "Upcoming Event: " + opportunity.name,
          'notification_type' => Notification.notification_types[:upcoming_opportunity],
          'message' => "This event is happening soon!"
        })

        notification.save!
      end
    end
  end

  # Create reoccurring opportunity notifications for opportunities the user has previously favorited  
  # opportunities: An array of Opportunity objects to attempt to make reoccurring notifications for
  # current_user: The User currently logged in
  # Note: This function does not currently work as Opportunity names must be unique and this function
  #   attempts to create reoccurring notifications based on the names of previously favorited Opportunities.
  def self.try_create_reoccurring_notifications(current_user, opportunities)

    # Only select opportunities that are favorited by the user
    opportunities = opportunities.select{ |opportunity| 
      FavoriteOpportunity.exists?(["opportunity_id = ? AND user_id = ?", opportunity.id, current_user.id])
    }

    opportunity_names = opportunities.collect{ |opportunity| opportunity.name }

    # Select any new opportunities similar to those the user previously favorited
    reoccurring_opportunities = Opportunity.where(
      ["id NOT IN(SELECT opportunity_id FROM favorite_opportunities) AND name IN (?)", opportunity_names])
    
    # Create reoccurring event notifications for any that don't yet have one
    reoccurring_opportunities.each do |opportunity|

      if !Notification.exists?(["opportunity_id = ? AND notification_type = ?", opportunity.id, Notification.notification_types[:reoccurring_opportunity]])
        
        notification = Notification.new({
          'organization' => opportunity.organization,
          'opportunity' => opportunity,
          'name' => "Reoccurring Event: " + opportunity.name,
          'notification_type' => Notification.notification_types[:reoccurring_opportunity],
          'message' => "An event you previously favorited is happening again!"
        })

        notification.save!
      end
    end
  end

  # Manage Notifications by notification type and delete any that have expired or are invalid
  def self.delete_expired(current_user)

    now = Time.now
    reminder_date = now + current_user.notification_period.days

    # Delete expired or invalid (due to event date edit) upcoming event notifications
    Notification.joins(:opportunity).where([
      "((opportunities.on_date = ? AND opportunities.end_time < ?) OR opportunities.on_date < ? OR opportunities.on_date > ?) AND notification_type = ?", 
      now,
      now.strftime("%T"),
      now,
      reminder_date,
      Notification.notification_types[:upcoming_opportunity]
    ]).delete_all

    # Delete expired reoccurring event notifications
    Notification.joins(:opportunity).where(["opportunities.on_date < ? AND notification_type = ?", 
      now, Notification.notification_types[:reoccurring_opportunity]]).delete_all
  end
end
