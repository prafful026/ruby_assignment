require "httparty"
require "nokogiri"

def is_valid_number_of_movies?(n)
  n > 0 && n <= 250
end

movie_db = {}

response = HTTParty.get("https://www.imdb.com/chart/top")
document = Nokogiri::HTML(response.body)

puts "Enter number of top movies to fetch from imdb top 250 movies list"

num_top_movies= gets.chomp.to_i

unless is_valid_number_of_movies? num_top_movies
  puts "invalid N"
  return
end

document.css(".lister-list tr").each_with_index do |row_element, index|

  if index >= num_top_movies
    break
  end

  anchor_element = row_element.css(".titleColumn a")
  movie_name = anchor_element.text
  movie_cast = anchor_element.attribute("title").to_s.downcase.split(", ").drop(1)
  movie_cast.each do |cast|
    if movie_db[cast].nil?
      movie_db[cast] = []
    end
    movie_db[cast] << movie_name
  end
end

puts movie_db.to_s

puts "Enter cast name & the number of their top movies to fetch"

cast_name = gets.chomp

num_top_movies_of_actor = gets.chomp.to_i

unless is_valid_number_of_movies? num_top_movies_of_actor
  puts "invalid M"
  return
end

movies_to_output = []

unless movie_db[cast_name].nil?
  movies_to_output = movie_db[cast_name][0..(num_top_movies_of_actor - 1)]
end

puts movies_to_output.to_s