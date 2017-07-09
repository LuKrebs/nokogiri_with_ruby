require 'pry-byebug'
require 'nokogiri'
require 'open-uri'

url = 'https://www.seejapan.co.uk/plan-your-trip/latest-offers'
file = open(url, "Accept-Language" => "en" )
doc = Nokogiri::HTML(file)

japan_title = doc.search('.tour-operator--title')
japan_text = doc.search('.tour-operator--text')

japan_title.each_with_index do |z, i|
  puts japan_title[i].text
  #puts japan_text[i].text
  puts ""
end
