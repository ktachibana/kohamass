require './env'
require 'rss'

get '/' do
  @water_levels = WaterLevel.asc(:day)
  erb :index
end

get '/feed.atom' do
  @water_levels = WaterLevel.desc(:day).limit(20)
  content_type :atom
  @water_levels.to_atom
end
