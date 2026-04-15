class MessageController < ApplicationController
  def index
    if params[:volunteers].present?
      @volunteers = params[:volunteers]
      @body = params[:email_body]
      #MessageMailer.send_mass_email(@volunteers, @body).deliver
    end
  end
end
