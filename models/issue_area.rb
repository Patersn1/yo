# frozen_string_literal: true

class IssueArea < ApplicationRecord
  validates_presence_of :name
end
