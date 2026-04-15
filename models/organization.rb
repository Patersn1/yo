# frozen_string_literal: true

#   Class: Organization

class Organization < ApplicationRecord
  alias_attribute :approved?, :approved

  # An organization can have multiple users
  has_many :users

  validates :name, presence: true, length: { in: 1..80 },
                   format: { with: /\A[a-z0-9A-Z'. :-]+\z/.freeze }

  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze },
                    uniqueness: { case_sensitive: false }

  validates :phone_no, presence: true,
                       format: { with: /\A(\+\d{1,2}\s)?\(?\d{3}\)?[\s.-]?\d{3}[\s.-]?\d{4}\z/ }

  validates :address, presence: true, length: { in: 1..100 },
                      format: { with: /\A[a-z0-9A-Z', -]+\z/.freeze }

  validates :city, presence: true, length: { in: 1..50 },
                   format: { with: /\A[a-zA-Z' -]+\z/.freeze }

  validates :state, presence: true, length: { in: 2..2 },
                    format: { with: /\A[A-Z]+\z/.freeze }

  validates :zip_code, presence: true,
                       numericality: { only_integer: true }, format: { with: /\A[0-9]+\z/.freeze }

  validates :description, presence: true, length: { in: 10..1000 }, confirmation: { case_sensitive: true },
                          format: { with: /\A[a-z0-9A-Z',. :-]+\z/.freeze }

  # Organization's owner
  belongs_to :user
  has_many :opportunities, dependent: :destroy

  has_many :users

  # No dependency action needed
  # has_many :favorite_organizations, dependent: destroy
  # has_many :users, through: :favorite_organizations

  belongs_to :tag, optional: true

  # Please, for the love of god, use this!
  def favorited_by
    FavoriteOrganization.where(organization: self).map(&:user)
  end

  def user_favorited?(usr)
    !FavoriteOrganization.where(user: usr, organization: self,).empty?
  end

  def get_favorite_organization_id(usr)
    FavoriteOrganization.where(user_id: usr.id, organization_id: self.id).first.id
  end
end
