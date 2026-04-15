# frozen_string_literal: true

class Photo < ApplicationRecord
  mount_uploader :attachment, AttachmentUploader
  validates :name, presence: true
end
