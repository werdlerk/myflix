require "spec_helper"

describe QueueItem do
  context 'relations' do
    it { should belong_to(:video) }
    it { should belong_to(:user) }
  end

end