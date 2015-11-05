require "spec_helper"

describe UserMailer do

  describe '#welcome' do
    let(:user) { Fabricate(:user) }
    let(:mail) { UserMailer.welcome(user) }

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

    it 'uses the users name in the email' do
      expect(mail.body.encoded).to match(user.name)
    end
  end

  describe '#reset_password' do
      let(:user) { Fabricate(:user) }
      let(:mail) { UserMailer.reset_password(user) }

      it 'renders the subject' do
        expect(mail.subject).to eq "Reset password"
      end

      it 'renders the receiver email' do
        expect(mail.to).to eq [ user.email ]
      end

      it 'renders the sender email' do
        expect(mail.from).to eq [ "werdlerk@gmail.com" ]
      end
      
      it 'sends the reset password url in the email' do
        expect(mail.body.encoded).to match(reset_password_url)
      end

      it 'uses the users name in the email' do
        expect(mail.body.encoded).to match(user.name)
      end
  end
end