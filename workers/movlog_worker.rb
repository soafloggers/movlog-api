# frozen_string_literal: true
require 'econfig'
require 'shoryuken'

# folders = 'lib,values,config,models,representers,services'
# Dir.glob("../{#{folders}}/init.rb").each do |file|
#   require file
# end

require_relative '../lib/init.rb'
require_relative '../values/init.rb'
require_relative '../config/init.rb'
require_relative '../models/init.rb'
require_relative '../representers/init.rb'
require_relative '../services/init.rb'

class MovlogWorker
  extend Econfig::Shortcut
  Econfig.env = ENV['RACK_ENV'] || 'development'

  Econfig.root = File.expand_path('..', File.dirname(__FILE__))

  Shoryuken.configure_client do |shoryuken_config|
    shoryuken_config.aws = {
      access_key_id:      MovlogWorker.config.AWS_ACCESS_KEY_ID,
      secret_access_key:  MovlogWorker.config.AWS_SECRET_ACCESS_KEY,
      region:             MovlogWorker.config.AWS_REGION
    }
  end

  include Shoryuken::Worker
  shoryuken_options queue: config.MOVLOG_QUEUE, auto_delete: true

  def perform(_sqs_msg, body)
    puts "123456787"
    puts body
    # puts queue_test
  end
end
