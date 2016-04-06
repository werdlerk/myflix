class UserMailer < ActionMailer::Base
  default from: 'info@myflix.com'

  def welcome(user_id)
    @user = User.find(user_id)
    mail to: %("#{@user.name}" <#{@user.email}>),
         subject: 'Welcome to MyFliX'
  end

  def reset_password(user_id)
    @user = User.find(user_id)
    mail to: %("#{@user.name}" <#{@user.email}>),
         subject: 'Reset password'
  end

  def payment_failed(user_id)
    @user = User.find(user_id)
    mail to: %("#{@user.name}" <#{@user.email}>),
         subject: 'Payment failed'
  end

end
