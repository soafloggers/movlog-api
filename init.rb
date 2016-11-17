# frozen_string_literal: true
Dir.glob('./{config,lib,models,controllers,services,representers,queries}/init.rb').each do |file|
  require file
end
