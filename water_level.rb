require 'open-uri'

class WaterLevel
  include Mongoid::Document
  include Mongoid::Timestamps
  field :day, type: Date
  field :value, type: Integer

  URL = 'https://www.city.mishima.shizuoka.jp/rakujyu/kohamaike_current.html'

  def self.load!
    doc = Nokogiri::HTML(open(URL))
    year_cell = doc.css('td:contains("今年")').last
    year = year_cell.text[/(\d+).*年/].to_i
    month = doc.css('td:contains("の水位")').last.text[/(\d+).*月/].to_i

    levels = year_cell.ancestors('table').first.css('tr').map do |tr|
      tds = tr.css('td') || next
      cell_texts = tds.map(&:text)
      next unless cell_texts.size == 3

      day = cell_texts[0].match(/(\d+)日/).try { |match| match[1].to_i } || next
      value = cell_texts[1].match(/\-?\d+/).try { |match| match[0].to_i } || next
      find_or_initialize_by(day: Date.new(year, month, day)) do |level|
        level.value = value
      end
    end.compact
    levels.each(&:save)
  end
end
