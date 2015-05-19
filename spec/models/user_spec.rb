require "spec_helper"

describe User do
  context 'relations' do
    it { should have_many(:reviews) }
    it { should have_many(:queue_items) }
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

end