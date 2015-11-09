require './env'

get '/' do
  @water_levels = WaterLevel.asc(:day)
  erb :index
end