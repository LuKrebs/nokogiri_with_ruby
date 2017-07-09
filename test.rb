require 'nokogiri'
require 'open-uri'

html_data = open('http://web.archive.org/web/20090220003702/http://www.sitepoint.com/').read
nokogiri_object = Nokogiri::HTML(html_data)
tagcloud_elements = nokogiri_object.css("ul.tagcloud > li > a")

tagcloud_elements.each do |tagcloud_element|
  puts tagcloud_element.text
end
