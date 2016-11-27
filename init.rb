# frozen_string_literal: true
folders = 'config,lib,models,representers,queries,services,controllers,values'
Dir.glob("./{#{folders}}/init.rb").each do |file|
  require file
end
