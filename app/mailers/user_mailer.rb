class UserMailer < ActionMailer::Base
  default from: 'werdlerk@gmail.com'

  def send_welcome(user)
    @user = user
    mail to: %("#{@user.name}" <#{@user.email}>),
         subject: 'Welcome to MyFliX'
  end

end
