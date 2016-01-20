require "spec_helper"

describe InvitationMailer do

  describe '#invite' do
    let(:user) { Fabricate(:user) }
    let(:invitation) { Fabricate(:invitation, author: user) }
    let(:mail) { InvitationMailer.invite(invitation.id) }

    it 'renders the subject' do
      expect(mail.subject).to eq "Invitation to MyFliX"
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq [ invitation.email ]
    end

    it 'renders the sender email' do
      expect(mail.from).to eql [ "info@myflix.com" ]
    end

    it 'uses the users name in the email' do
      expect(mail.body.encoded).to match(invitation.name)
    end
  end

end
