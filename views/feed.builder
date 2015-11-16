xml.instruct! :xml, version: '1.0'
xml.feed xmlns: 'http://www.w3.org/2005/Atom' do
  xml.title '小浜池の水位 - kohamass', type: 'text', 'xml:lang' => 'ja'
  xml.id 'tag:kohamass.herokuapp.com/'
  xml.link href: 'https://kohamass.herokuapp.com/feed.xml', type: 'application/atom+xml', rel: 'self'
  xml.link href: 'https://www.city.mishima.shizuoka.jp/rakujyu/', type: 'text/html', rel: 'alternate'
  xml.subtitle '「小浜池」の水位は標高25.69m（池中央付近の池底部分）を0cmとし、毎日計測しています。', type: 'text'
  xml.updated (@water_levels.max(:updated_at) || Time.current).iso8601

  @water_levels.each do |level|
    xml.entry do
      xml.title level.day.strftime('%Y年%-m月%-d日の小浜池の水位'), type: 'text'
      xml.id "tag:kohamass.herokuapp.com/#{level.day.strftime('%F')}"
      xml.link href: 'https://www.city.mishima.shizuoka.jp/rakujyu/kohamaike_current.html'
      xml.content "#{level.value} cm", type: 'text'
      xml.updated (level.updated_at || level.day.to_time).iso8601
      xml.author do
        xml.name 'Kenichi Tachibana'
      end
    end
  end
end
