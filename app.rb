require './env'
require 'rss'

get '/' do
  @water_levels = WaterLevel.asc(:day)
  erb :index
end

get '/feed.xml' do
  @water_levels = WaterLevel.desc(:day).limit(20)
  content_type :atom
  builder :feed
end
