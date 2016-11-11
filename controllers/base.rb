require 'sinatra'
require 'econfig'

#configure based on environment
class MovlogAPI < Sinatra::Base
  extend Econfig::Shortcut

  Econfig.env = settings.environment.to_s
  Econfig.root = File.expand_path('..', settings.root)
  Skyscanner::SkyscannerApi.config.update(api_key: config.SKY_API_KEY)
  Airbnb::AirbnbApi.config.update(client_id: config.AIRBNB_CLIENT_ID)
end

configure :development, :production do
  require 'hirb'
  Hirb.enable
end
