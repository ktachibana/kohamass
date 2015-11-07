class WaterLevel
  include Mongoid::Document
  field :day, type: Date
  field :value, type: Integer
end
