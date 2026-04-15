class OpportunityMailer < ApplicationMailer
    def new_opportunity(opportunity, email)
        # emails the user of the new event
        @opportunity = opportunity
        @user = email
        mail to: email, 
             from: "servdteam@servd.org",
             subject: opportunity.organization.name + " created a new event!"
    end 
end
