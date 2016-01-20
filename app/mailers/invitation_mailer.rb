class InvitationMailer < ActionMailer::Base
  default from: 'info@myflix.com'

  def invite(invitation_id)
    @invitation = Invitation.find(invitation_id)
    mail to: %("#{@invitation.name}" <#{@invitation.email}>),
         subject: 'Invitation to MyFliX'
  end

end
