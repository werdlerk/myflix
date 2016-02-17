require 'spec_helper'
require 'carrierwave/test/matchers'

describe SmallCoverUploader do
  include CarrierWave::Test::Matchers

  let(:video) { Fabricate(:video) }

  before do
    SmallCoverUploader.enable_processing = true
    @uploader = SmallCoverUploader.new(video, :cover)

    File.open(File.join(Rails.root, 'public', 'tmp', 'family_guy.jpg')) do |f|
      @uploader.store!(f)
    end
  end

  after do
    SmallCoverUploader.enable_processing = false
    @uploader.remove!
  end

  it "should make the image readable only to the owner and not executable" do
    expect(@uploader).to have_permissions(0644)
  end

  it "should resize to fill the image to be 665 by 375 pixels" do
    expect(@uploader).to have_dimensions(166, 236)
  end
end
