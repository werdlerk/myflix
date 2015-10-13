require "spec_helper"

describe Followship do
  context 'relations' do
    it { should belong_to(:user) }
    it { should belong_to(:follower).class_name('User') }
  end
end