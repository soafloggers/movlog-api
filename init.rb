# frozen_string_literal: true
Dir.glob('./{config,lib,models,representers,queries,services,controllers}/init.rb').each do |file|
  require file
end
