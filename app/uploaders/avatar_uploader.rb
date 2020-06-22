class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::ImageOptimizer

  ## Set Default Image of Challenge
  def default_url(*args)
    ActionController::Base.helpers.asset_path('logo-files/default-user-icon.jpg')
  end

  #thumb version
  version :thumb do
    process :resize_to_fill => [100, 100]
    process optimize: [{ quality: 50 }]
  end
  #Banner version
  version :banner do
    process :quality => 40
  end

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :aws
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def download_url(filename)
    url(response_content_disposition: %Q{attachment; filename="#{filename}"})
  end

  ## Directory Structure in S3
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url(*args)
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process scale: [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  ## Create different versions of your uploaded files:
  # version :thumb, :if => :thumb? do
  #   process :resize_to_fill => [100, 100]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_whitelist
    %w(jpg jpeg gif png svg)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

  ## Check Whether you want to create Thumbnail or NOT
  def thumb?(file_name)
    model.class.to_s != 'CampaignTemplateDetail'
  end

  #optimizing the image
  def optimize(img)
    manipulate! do |img|
        return img unless ["JPEG", "JPG", "PNG", "SVG", "GIF"].include?(img.type)
        img.strip
        img.combine_options do |c|
            c.quality "80"
            c.depth "8"
            c.interlace "plane"
        end
        img
    end
  end
  #optimizing the image quality
  def quality(percentage)
    manipulate! do |img|
      if img.size >= 1048576
        img.quality(percentage.to_s)
        img = yield(img) if block_given?
      end
      img
    end
  end
end
