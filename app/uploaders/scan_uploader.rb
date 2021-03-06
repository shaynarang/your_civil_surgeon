# encoding: utf-8

class ScanUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  Rails.env.production? ? (storage :fog) : (storage :file)

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/patients/#{model.patient_id}/medical_records/#{model.id}/"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  version :thumb do
    if :pdf?
      process :convert => 'png'
      def full_filename (for_file = model.artifact.file)
        super.chomp(File.extname(super)) + '.png'
      end
    end
    process :resize_to_fit => [100, 100]
  end

  version :full do
    return unless :pdf?
    process :convert => 'png'
    def full_filename (for_file = model.artifact.file)
      super.chomp(File.extname(super)) + '.png'
    end
    process :resize_to_fit => [1366, 768]
  end

  def pdf?(new_file)
    new_file.content_type.include? '/pdf'
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg jpg_large gif png pdf)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end
