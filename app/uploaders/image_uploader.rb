# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  process resize_to_fit: [800, 800]

  version :preview do
    process resize_to_fill: [200, 300]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

end
