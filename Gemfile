source 'https://rubygems.org'
ruby '2.5.8'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.1.7'
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.0'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'jquery-rails'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'devise'
gem 'inherited_resources'
gem 'activeadmin', '~> 1.3.1'
gem 'mini_magick'
gem 'fog-aws'
gem 'carrierwave'
gem 'formadmin'
gem 'fullcalendar-rails'
gem 'momentjs-rails'
gem 'select2-rails'
gem 'bootstrap-popover-rails'
gem 'bourbon'
gem 'neat', '~> 1.8'
gem 'slim'
gem 'loofah', '>= 2.2.3'

group :development, :test do
  gem 'byebug', platform: :mri
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
