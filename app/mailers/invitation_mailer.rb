class InvitationMailer < ActionMailer::Base
  default from: 'info@myflix.com'

  def invite(invitation)
    @invitation = invitation
    mail to: %("#{@invitation.name}" <#{@invitation.email}>),
         subject: 'Invitation to MyFliX'
  end

end
