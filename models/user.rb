# Project name: SERVD
# Description: application for organizating volunteers and community events
# Filename: user.rb
# Description: sets up framework for user object
# Last modified on: 03/26

# frozen_string_literal: true

#   Class: User
#
#   Functions:
#     login?(email, password)
#     from_email(email)
#     register(email, password, type)
#     delete_account()
#     set_email(new_email)
#     set_password(new_password)

class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  before_save { self.email = email.downcase }
  # Removed automatic email on account creation to disable verification emails.

  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  validates :password, presence: true, length: { minimum: 6 }

  # add validation for new attributes
  # validates :major, format: { with: /\A[a-zA-Z]+\z/.freeze }
  # validates :academic_year, format: { with: /\A[a-zA-Z]+\z/.freeze }
  # validates :interest, format: { with: /\A[a-zA-Z]+\z/.freeze }

  has_one :organization, dependent: :destroy

  # FIXME: Broken association
  # Fix assigned to @EthanZeigler
  #
  # Temp through function
  # has_one :organization, dependent: :nullify
  belongs_to :tag, optional: true

  has_many :favorite_opportunities, dependent: :destroy
  # has_many :opportunties, through: :favorite_opportunities

  has_many :favorite_organizations, dependent: :destroy
  # has_many :organizations, through: :favorite_organizations

  # Has many roles through :roles
  has_and_belongs_to_many :roles

  # A user can belong to an organization, but it is not required
  belongs_to :organization, optional: true

  # Method to check a user's role
  def has_role?(role_name)
    roles.exists?(name: role_name)
  end

  # Assigns a role to the user if they don't already have it
  def assign_role(role)
    roles << role unless has_role?(role.name)
  end

  # Removes a role from the user
  def remove_role(role)
    roles.delete(role)
  end

  def favorite_opportunities
    puts("#############################################\n\n\n\n\n")
    puts("Please do not use favorite_opportunities. It's a temporary bandaid")
    puts("\n\n\n\n\n###########################################")
    self[:favorite_opportunities]
  end

  def favorite_organizations
    puts("#############################################\n\n\n\n\n")
    puts("Please do not use favorite_organizations. It's a temporary bandaid")
    puts("\n\n\n\n\n###########################################")
    self[:favorite_organizations]
  end

  def volunteered_opportunities
    Volunteer.where(user: self).map(&:opportunity)
  end

  def favorited_opportunities
    FavoriteOpportunity.where(user: self).map(&:opportunity)
  end

  def favorited_organizations
    FavoriteOrganization.where(user: self).map(&:organization)
  end

  def org?
    !organization.nil?
  end

  def approved_org?
    !organization.nil? && organization.approved?
  end

  def invalid_org?
    !organization.nil? && !organization.approved?
  end

  # def new_user
  #   UserMailer.new_user(self).deliver
  # end
end
