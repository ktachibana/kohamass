class RootController < ApplicationController
  def index
    @water_levels = WaterLevel.asc(:day)
  end
end
