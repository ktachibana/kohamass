require 'bundler'
rack_env = ENV['RACK_ENV'] || 'development'

Bundler.require(:default, rack_env)

require 'sinatra'
require 'tilt/erb'
Mongoid.load!('./config/mongoid.yml', rack_env)
require './water_level'
