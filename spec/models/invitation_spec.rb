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

end
