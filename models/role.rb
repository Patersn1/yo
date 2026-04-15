class Role < ApplicationRecord
  has_and_belongs_to_many :users

  # Validate that a role is present and unique
  validates :name, presence: true, uniqueness: true
end
