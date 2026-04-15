# Project name: SERVD
# Description: application for organizating volunteers and community events
# Filename: opportunity.rb
# Description: blueprint for creating a new opportunity object
# Last modified on: 11/08

# frozen_string_literal: true

##
# A CEL opportunity registered with an organization
class Opportunity < ApplicationRecord
  alias_attribute :approved?, :approved
  before_save { self.state = state.upcase }
  after_create :new_opportunity

  validates :name, presence: true, length: { in: 1..100 },
                   format: { with: /\A[a-z0-9A-Z' :-]+\z/.freeze }

  validates :address, presence: true, length: { in: 1..100 },
                      format: { with: /\A[a-z0-9A-Z', -]+\z/.freeze }

  validates :city, presence: true, length: { in: 1..50 },
                   format: { with: /\A[a-zA-Z' -]+\z/.freeze }

  #NK Altered accepted format for state field            
  validates :state, presence: true, length: { in: 2..2 },
                    format: { with: /\A[a-zA-Z]+\z/.freeze }

  validates :zip_code, presence: true,
                       numericality: { only_integer: true }, format: { with: /\A[0-9]+\z/.freeze }

  validates :description, presence: true, length: { in: 1..1000 }, confirmation: { case_sensitive: true },
                          format: { with: /\A[a-z0-9A-Z',. :-]+\z/.freeze }

  validates :frequency, presence: true, length: { in: 1..30 }, confirmation: { case_sensitive: true },
                        format: { with: /\A[a-z0-9A-Z', -]+\z/.freeze }

  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze }

  validate :check_start_and_end_times

  # FIXME: shouldn't be optional long term
  belongs_to :organization, foreign_key: 'organization_id'
  belongs_to :tag, optional: true

  has_many :favorite_opportunities, dependent: :destroy
  has_many :opportunities, through: :favorite_opportunities

  # has_many :opportunities_tags
  # has_many :tags, through: :opportunities_tags

  validates_uniqueness_of :name, scope: :email

  ##
  # True if the given user owns the opportunity
  def owned_by?(user)
    if user.nil?
      false
    else
      organization == user.organization
    end
  end

  def self.search(search)
    if search != ''
      tag1 = where(primary_tag_id: search)
      tag2 = where(secondary_tag_id: search)
      if tag1
        tag1
      elsif tag2
        tag2
      else
        Opportunity.all
      end
    else
      Opportunity.all
    end
  end

  def volunteers
    Volunteer.where(opportunity_id: self.id)
  end

  def favorited_by
    FavoriteOpportunity.where(opportunity: self).map(&:user)
  end

  def user_favorited?(usr)
    !FavoriteOpportunity.where(user: usr, opportunity: self).empty?
  end

  def get_favorite_opportunity_id(usr)
    FavoriteOpportunity.where(user_id: usr.id, opportunity_id: self.id).first.id
  end

  def check_start_and_end_times
    if start_time > end_time
      errors.add(:end_time, 'cannot be earlier than the start time')
    end
  end

  def new_opportunity
    @subscribers = FavoriteOrganization.where(organization: self.organization).map(&:user)
        
    # emails all subscribers of the organization
    @subscribers.each do |user|
    OpportunityMailer.new_opportunity(self, user.email).deliver
    end

    OpportunityMailer.new_opportunity(self, self.organization.email).deliver
  end
end
