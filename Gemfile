source "https://rubygems.org"

ruby "2.3.0"

gem "bundler-audit"
gem "coffee-rails", "~> 4.1.0"
gem "jquery-rails"
gem "kaminari"
gem "lograge"
gem "octokit"
gem "omniauth-github"
gem "pg", "~> 0.18"
gem "puma"
gem "rails", ">= 5.0.0.beta3", "< 5.1"
gem "rollbar"
gem "sass-rails", "~> 5.0"
gem "sidekiq"
gem "uglifier", ">= 1.3.0"

group :development, :test do
  gem "byebug"
  gem "rspec-rails"
  gem "dotenv-rails"
  gem "rubocop"
end

group :test do
  gem "webmock"
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem "web-console", "~> 3.0"
  gem "listen", "~> 3.0.5"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]

group :production do
  gem "rails_12factor"
end
