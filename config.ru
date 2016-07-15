require 'bundler/setup'
require_relative './app'

set :public_folder, File.dirname(__FILE__) + '/tmp'

run App
