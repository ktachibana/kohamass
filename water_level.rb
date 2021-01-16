require 'open-uri'

class WaterLevel
  include Mongoid::Document
  include Mongoid::Timestamps
  field :day, type: Date
  field :value, type: Integer

  URL = 'https://www.city.mishima.shizuoka.jp/rakujyu/kohamaike_current.html'

  def self.load!(today: Date.today)
    doc = Nokogiri::HTML(open_water_levels_page)

    year = today.year
    content_elm = doc.css('#maincontent')
    month = content_elm.css('h1:contains("の水位")').first.text[/(\d+)月/, 1]&.to_i || raise('month value was not found.')

    levels = content_elm.css('table').first.css('tr').map do |tr|
      tds = tr.css('td') || next
      cell_texts = tds.map(&:text)
      next unless cell_texts.size == 4

      day = cell_texts[0].match(/(\d+)日/).try! { |match| match[1].to_i } || next
      value = cell_texts[1].match(/\-?\d+/).try! { |match| match[0].to_i } || next

      date = Date.new(year, month, day)
      next if today < date

      find_or_initialize_by(day: date).tap do |level|
        level.value = value
      end
    end.compact
    levels.each(&:save)
  end

  private

  def self.open_water_levels_page
    URI.open(URL)
  end
end
