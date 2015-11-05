class UserMailer < ActionMailer::Base
  default from: 'werdlerk@gmail.com'

  def welcome(user)
    @user = user
    mail to: %("#{@user.name}" <#{@user.email}>),
         subject: 'Welcome to MyFliX'
  end

  def reset_password(user)
    @user = user
    mail to: %("#{@user.name}" <#{@user.email}>),
         subject: 'Reset password'
  end

end
