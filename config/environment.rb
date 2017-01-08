# frozen_string_literal: true
require 'sinatra'
require 'sequel'

configure :development do
  ENV['DATABASE_URL'] = 'sqlite://db/dev.db'
end

configure :test do
  ENV['DATABASE_URL'] = 'sqlite://db/test.db'
end

configure do
  DB = Sequel.connect(ENV['DATABASE_URL'])
  ENV['SKY_API_KEY'] = 'ni383467859431493982729572338504'
  ENV['AIRBNB_CLIENT_ID'] = '3092nxybyb0otqw18e8nh5nty'
  ENV['GEONAMES_USERNAME'] = 'z255477'
  ENV['GOOGLEMAP_KEY'] = 'AIzaSyDD0FgUKqfUupluqIaRU5eKWxGBcOSFmzs'
  ENV['AWS_ACCESS_KEY_ID'] = 'AKIAI7GDT3TVT35KUTYQ'
  ENV['AWS_SECRET_ACCESS_KEY'] = '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'
  ENV['MOVLOG_QUEUE'] = 'movlog'
  ENV['AWS_REGION'] = 'ap-northeast-1'
  require 'hirb'
  Hirb.enable
end
