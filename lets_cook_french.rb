require 'pry-byebug'
require 'nokogiri'
require 'open-uri'

file = 'strawberry.html'
doc = Nokogiri::HTML(File.open(file), nil, 'utf-8')

food_name = doc.search('.m_titre_resultat > a')
food_info = doc.search('.m_texte_resultat')
#food_time = doc.search('.m_detail_time')

base_url = "http://www.letscookfrench.com"

food_name.each_with_index do |food, index|
  puts food_name[index].text
  individual_page = base_url + food.attribute('href')
  file = open(individual_page, "Accept-Language" => "en")
  doc = Nokogiri::HTML(file)
  food_time = doc.search('span.preptime').text
  food_dificult = doc.search('.m_content_recette_breadcrumb').text.delete("-").split("\r")[2].strip
  p food_dificult
end
