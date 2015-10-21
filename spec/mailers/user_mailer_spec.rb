require "spec_helper"

describe UserMailer do

  describe '#send_welcome' do
    let(:user) { Fabricate(:user) }
    let(:mail) { UserMailer.send_welcome(user) }

    it 'renders the subject' do
      expect(mail.subject).to eq "Welcome to MyFliX"
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq [ user.email ]
    end

    it 'renders the sender email' do
      expect(mail.from).to eql [ "werdlerk@gmail.com" ]
    end

    it 'uses the users email address in the email' do
      expect(mail.body.encoded).to match(user.email)
    end
  end
end