task default: 'kohamass:load'

namespace :kohamass do
  desc '小浜池の水位データを公式ページから取得する'
  task :load do
    require './env'
    WaterLevel.load!
  end
end
