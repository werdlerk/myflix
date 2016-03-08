class LargeCoverUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  process :resize_to_fill => [665, 375]

  def extension_whitelist
    %w(jpg jpeg gif png)
  end
end
