require "spec_helper"

describe User do
  context 'relations' do
    it { should have_many(:reviews).order(:created_at) }
    it { should have_many(:queue_items).order(:position) }
    it { should have_many(:followships) }
    it { should have_many(:followers).through(:followships) }
  end

  context 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password) }
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:email) }
  end

  context 'authentication' do
    it { should have_secure_password }
  end

  describe :queued_video? do
    let(:user) { Fabricate(:user) }
    let(:video) { Fabricate(:video) }
    let(:video2) { Fabricate(:video) }
    let(:queue_item) { Fabricate(:queue_item, video: video, user: user) }

    it "returns false when there are no videos queued" do
      expect(user.queued_video?(video)).to be false
    end

    it "returns false when the given video is not queued" do
      queue_item
      expect(user.queued_video?(video2)).to be false
    end

    it "returns true when the given video is already queued" do
      queue_item
      expect(user.queued_video?(video)).to be true
    end
  end

end