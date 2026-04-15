# frozen_string_literal: true

class CreateUsersOpportunitiesJoinTables < ActiveRecord::Migration[5.2]
  def change
    create_table :users_opportunities_join_tables do |t|
      t.references :user, index: true, foreign_key: true
      t.references :opportunity, index: true, foreign_key: true
      t.timestamps
    end
  end
end
