ENV['RACK_ENV'] ||= 'test'
require './env'

RSpec.configure do |config|
  config.before { WaterLevel.delete_all }
end
