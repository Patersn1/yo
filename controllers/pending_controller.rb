# Project name: Assignment2
# Description: Storing approved organizations in a database.
# Filename: pending_controller.rb
# Description: Takes organizations and events awaiting approval.
# Last modified on: 10/30/2021

class PendingController < ApplicationController
    def index
      @checkorg = Organization.where(approved: false,user_id: current_user.id)
      @checkopp = Opportunity.where(approved: false)
    end
  end
  