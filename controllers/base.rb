require 'sinatra'
require 'econfig'

#configure based on environment
class MovlogAPI < Sinatra::Base
  extend Econfig::Shortcut

  Shoryuken.configure_server do |config|
    config.aws = {
      access_key_id:      config.AWS_ACCESS_KEY_ID,
      secret_access_key:  config.AWS_SECRET_ACCESS_KEY,
      region:             config.AWS_REGION
    }
  end

  API_VER = 'api/v0.1'

  configure do
    Econfig.env = settings.environment.to_s
    Econfig.root = File.expand_path('..', settings.root)
    Skyscanner::SkyscannerApi.config.update(api_key: config.SKY_API_KEY)
    Airbnb::AirbnbApi.config.update(client_id: config.AIRBNB_CLIENT_ID)
    Airports::GeonamesApi.config.update(username: config.GEONAMES_USERNAME)
    Airports::GoogleMapApi.config.update(key: config.GOOGLEMAP_KEY)
  end

  get '/?' do
    "MovlogAPI latest version endpoints are at: /#{API_VER}/"
  end
end
