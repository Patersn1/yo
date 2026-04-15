# frozen_string_literal: true

class DropIssueAreasTable < ActiveRecord::Migration[5.2]
  def change
    drop_table :issue_areas, force: :cascade
  end
end
