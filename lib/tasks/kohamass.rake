namespace :kohamass do
  desc '小浜池の水位データを公式ページから取得する'
  task load: :environment do
    WaterLevel.load!
  end
end
