require 'spec_helper'
require 'carrierwave/test/matchers'

describe LargeCoverUploader do
  include CarrierWave::Test::Matchers

  let(:video) { Fabricate(:video) }

  before do
    LargeCoverUploader.enable_processing = true
    @uploader = LargeCoverUploader.new(video, :cover)

    File.open(File.join(Rails.root, 'public', 'tmp', 'family_guy.jpg')) do |f|
      @uploader.store!(f)
    end
  end

  after do
    LargeCoverUploader.enable_processing = false
    @uploader.remove!
  end

  it "should make the image readable only to the owner and not executable" do
    expect(@uploader).to have_permissions(0644)
  end

  it "should resize to fill the image to be 665 by 375 pixels" do
    expect(@uploader).to have_dimensions(665, 375)
  end
end
