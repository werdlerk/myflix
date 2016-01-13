require "spec_helper"

describe User do
  context 'relations' do
    it { should have_many(:reviews).order(created_at: :desc) }
    it { should have_many(:queue_items).order(:position) }
    it { should have_many(:following_relationships).class_name('Relationship').with_foreign_key(:follower_id) }
    it { should have_many(:followers).through(:leading_relationships) }
    it { should have_many(:leading_relationships).class_name('Relationship').with_foreign_key(:leader_id) }
    it { should have_many(:leaders).through(:following_relationships) }
    it { should have_many(:invitations) }
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

  it_behaves_like "tokenable" do
    let(:object) { Fabricate(:user) }
  end

  describe '#queued_video?' do
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

  describe '#follows?' do

    it 'returns true if the user has a following relationship with another user' do
      john = Fabricate(:user)
      anne = Fabricate(:user)
      Fabricate(:relationship, leader: john, follower: anne)

      expect(anne.follows?(john)).to eq true
    end

    it 'returns false if the user does not have a following relationship with another user' do
      john = Fabricate(:user)
      anne = Fabricate(:user)
      Fabricate(:relationship, leader: john, follower: anne)

      expect(john.follows?(anne)).to eq false
    end
  end

  describe '#follow!' do
    it 'follows another user' do
      john = Fabricate(:user)
      anne = Fabricate(:user)

      anne.follow!(john)

      expect(anne.follows?(john)).to eq true
    end

    it 'does not follow oneself' do
      john = Fabricate(:user)

      john.follow!(john)

      expect(john.follows?(john)).to eq false
    end
  end

end
