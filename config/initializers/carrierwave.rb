if Rails.env.production?
  CarrierWave.configure do |config|
    config.storage = :fog
    config.fog_use_ssl_for_aws = true
    config.fog_directory = ENV['S3_BUCKET_NAME']
    config.fog_public = false
    config.fog_authenticated_url_expiration = 120
    config.fog_provider = 'fog/aws'
    config.fog_credentials = {
      :provider              => 'AWS',
      :aws_access_key_id     => ENV['S3_KEY'],
      :aws_secret_access_key => ENV['S3_SECRET'],
      :region                => 'us-west-2'
    }
  end
end
