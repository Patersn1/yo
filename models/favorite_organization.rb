# frozen_string_literal: true

class FavoriteOrganization < ApplicationRecord
  belongs_to :user
  belongs_to :organization

  validates :user_id, uniqueness: { scope: :organization_id,
                                    message: 'cannot favorite the same organization twice!' }
end
