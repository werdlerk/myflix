require "spec_helper"

describe Relationship do
  context 'relations' do
    it { should belong_to(:user) }
    it { should belong_to(:follower).class_name('User') }
  end
end