# frozen_string_literal: true
folders = 'config,lib,models,values,representers,queries,services,controllers,workers'
Dir.glob("./{#{folders}}/init.rb").each do |file|
  require file
end
