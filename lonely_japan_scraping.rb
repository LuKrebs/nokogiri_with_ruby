require 'pry-byebug'
require 'nokogiri'
require 'open-uri'
require 'csv'

base_url = 'http://www.lonelyplanet.com'

url = 'http://www.lonelyplanet.com/japan/top-things-to-do/a/poi/356635'
file = open(url, "Accept-Language" => "en" )
doc = Nokogiri::HTML(file)

japan_anchor = doc.search('.ListItem-title > a')
japan_title = doc.search('.ListItem-title')
japan_text = doc.search('.ListItem-description')
japan_category = doc.search('.ListItem-category')

japan_title.each_with_index do |place, index|
  japan_place = {category: japan_category[index].text }
  japan_place[:title] = japan_title[index].text
  japan_place[:text] = japan_text[index].text
  japan_place[:url] = base_url + japan_anchor[index].attributes['href'].value


  new_link = Nokogiri::HTML(open(japan_place[:url],  "Accept-Language" => "en" ))

  new_link_heading = new_link.search('h4.Heading')
  new_link_side_bar = new_link.search('div.SidebarSection-content')

  japan_place[:extra_info] = "#{new_link_heading[0].text} #{new_link_side_bar[0].text}"

  filepath = "japan_places.csv"
  CSV.open(filepath, "w") do |csv|
    csv << [japan_place[:title], japan_place[:category], japan_place[:text], japan_place[:extra_info], japan_place[:url]]
  end
  puts "Successfully wrote #{japan_place[:title]}"
end
