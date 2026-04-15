class MessageMailer < ApplicationMailer
    # Default email, should be changed
    default from: 'servd@example.com'
    
    # Send mass email to volunteers
    def send_mass_email(volunteers, message)
        @recipients = volunteers
        @recipients.each do |recipient|
            mail(to: recipient.email, subject: 'You have a message from an organization on SERVD!')
        end
    end
end
