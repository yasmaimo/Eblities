source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.1.6'
gem 'sqlite3'
gem 'puma', '~> 3.7'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'

# bootstrap
gem 'bootstrap', '~>4.1.1'
gem 'jquery-rails'

# 画像投稿用
gem "refile", require: "refile/rails", github: 'manfe/refile'
gem "refile-mini_magick"
gem 'carrierwave'

# ログイン機能
gem 'devise'

# SNSログイン機能
gem 'omniauth'
gem 'omniauth-twitter'
gem 'omniauth-facebook'
gem 'omniauth-google-oauth2'

# soundcloudログイン機能 使用未定 使えないかも
# gem 'omniauth-soundcloud', '~> 1.0.0'

# pixivログイン機能 使用未定 使えないかも
# gem "omniauth-pixiv-public"

# 二段階認証機能
gem 'devise-two-factor'
gem 'rqrcode-rails3'
# gem 'google-authenticator-rails'

# タグ付け用
gem 'acts-as-taggable-on', '~> 6.0'

# もっと見る機能
gem 'kaminari'

# 検索機能用
gem 'ransack'

# font-awesome用
gem 'font-awesome-rails'

# 初期データ投入用
gem 'seed-fu', '~> 2.3'

# 記事投稿用
gem 'simple_form', '~> 3.5.1'
gem 'summernote-rails', github: 'summernote/summernote-rails'

# reCAPTCHA認証
gem "recaptcha", require: "recaptcha/rails"

# 環境変数管理
gem 'dotenv-rails'

# メールの送信確認 使用未定
# gem 'letter-opener'
# gem 'mailcatcher'

# メッセージ日本語化 使用未定
# gem 'rails-i18n'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'

  # デバッグ用
  gem 'pry-rails'
  gem 'pry-byebug'
  gem 'pry-doc'
  gem 'hirb'
  gem 'hirb-unicode'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
