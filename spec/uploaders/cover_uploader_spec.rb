require 'spec_helper'
require 'carrierwave/test/matchers'

describe CoverUploader do
  include CarrierWave::Test::Matchers

  let(:video) { Fabricate(:video) }

  before do
    CoverUploader.enable_processing = true
    @uploader = CoverUploader.new(video, :cover)

    File.open(File.join(Rails.root, 'public', 'tmp', 'family_guy.jpg')) do |f|
      @uploader.store!(f)
    end
  end

  after do
    CoverUploader.enable_processing = false
    @uploader.remove!
  end

  it "should make the image readable only to the owner and not executable" do
    expect(@uploader).to have_permissions(0644)
  end
end
