require './env'

get '/' do
  @water_levels = WaterLevel.desc(:day)
  erb :index
end

get '/feed.xml' do
  @water_levels = WaterLevel.desc(:updated_at).limit(31)
  content_type :atom
  builder :feed
end
