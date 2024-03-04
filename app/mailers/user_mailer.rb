class UserMailer < ApplicationMailer
  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to Online Course Platform')
  end

  def deletion_email(user)
    @user = user
    mail(to: @user.email, subject: 'Account Deletion')
  end
end
