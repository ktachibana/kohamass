require 'bundler'
Bundler.require

require 'sinatra'
require 'tilt/erb'
Mongoid.load!('./config/mongoid.yml')
require './water_level'
