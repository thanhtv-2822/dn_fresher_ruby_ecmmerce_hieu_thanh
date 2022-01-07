source "https://rubygems.org"
git_source(:github){|repo| "https://github.com/#{repo}.git"}

ruby "2.7.0"
gem "active_storage_validations", "0.8.2"
gem "bcrypt", "3.1.12"
gem "bootsnap", ">= 1.4.4", require: false
gem "bootstrap-sass", "~> 3.4", ">= 3.4.1"
gem "config"
gem "devise", "~> 4.1"
gem "faker", "2.1.2"
gem "figaro"
gem "image_processing", "1.9.3"
gem "jbuilder", "~> 2.7"
gem "mini_magick", "4.9.5"
gem "mysql2", "~> 0.5.2"
gem "pagy"
gem "puma", "~> 5.0"
gem "rails", "~> 6.1.4", ">= 6.1.4.1"
gem "rails-i18n"
gem "sass-rails", ">= 6"
gem "turbolinks", "~> 5"
gem "webpacker", "~> 5.0"

group :development, :test do
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  gem "rspec-rails", "~> 4.0.1"
  gem "rubocop", "~> 0.74.0", require: false
  gem "rubocop-checkstyle_formatter", require: false
  gem "rubocop-rails", "~> 2.3.2", require: false
end

group :development do
  gem "listen", "~> 3.3"
  gem "rack-mini-profiler", "~> 2.0"
  gem "spring"
  gem "web-console", ">= 4.1.0"
end

group :test do
  gem "capybara", ">= 3.26"
  gem "database_cleaner"
  gem "factory_bot_rails"
  gem "rails-controller-testing"
  gem "selenium-webdriver"
  gem "shoulda-matchers", "~> 5.0"
  gem "simplecov"
  gem "simplecov-rcov"
  gem "webdrivers"
end

gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
