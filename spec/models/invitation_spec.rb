require "spec_helper"

describe Invitation do
  context 'relations' do
    it { should belong_to :author }
  end

  context 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :email }
    it { should validate_presence_of :message }
  end

  it_behaves_like "tokenable" do
    let(:object) { Fabricate(:invitation) }
  end

  describe '#clear_token!' do
    it 'clears the token' do
      invitation = Fabricate(:invitation, token: "DEF")
      invitation.clear_token!
      expect(invitation.reload.token).to be_nil
    end
  end

end
