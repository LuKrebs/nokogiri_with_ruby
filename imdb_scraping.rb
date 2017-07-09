require 'pry-byebug'
require 'nokogiri'
require 'open-uri'

base_url = 'http://www.imdb.com'
url = 'http://www.imdb.com/chart/top'
file = open(url, "Accept-Language" => "en" )
doc = Nokogiri::HTML(file)

movies_doc = doc.search('.titleColumn a')
movies_doc[0..99].each do |movie_doc|
  movie = {title: movie_doc.text}
  movie[:url] = base_url + movie_doc.attributes["href"].value
  movie_doc = Nokogiri::HTML(open(movie[:url], "Accept-Language" => "en"))

  movie[:release] = movie_doc.search('.title_wrapper').search('#titleYear').text.gsub('(', '').gsub(')', '')
  movie[:duration] = movie_doc.search('.title_wrapper').search('time').text.strip

  stars = movie_doc.search('.credit_summary_item')[2].search('a span').map { |star| star.text }
  stars.delete('|')
  n = stars.length

  movie[:stars] = ""
  # Build the string 'John, Paul, Georges and Ringo'
  stars.each_with_index do |name, index|
    if index + 1 == n
      movie[:stars] += " and #{name}."
    elsif index + 1 == n -1
      movie[:stars] += name
    else
      movie[:stars] += "#{name}, "
    end
  end

  movie_text = "Title: #{movie[:title]}\n"
  movie_text += "Release date: #{movie[:release]}\n"
  movie_text += "Duration: #{movie[:duration]}\n"
  movie_text += "Starring: #{movie[:stars]}"

  puts movie_text

  filepath = "#{movie[:title].downcase.gsub(' ', '_')}.txt"
  File.open(filepath, "w") do |file|
    file.write(movie_text)
  end
  puts "Successfully wrote #{filepath}"
end
