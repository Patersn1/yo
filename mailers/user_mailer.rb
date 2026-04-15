class UserMailer < ApplicationMailer
    def new_user(user)
        # emails the user when their account is created
        @user = user.email
        mail to: @user, 
             from: "servdteam@servd.org",
             subject: "Welcome to SERVD!"
    end 
end
