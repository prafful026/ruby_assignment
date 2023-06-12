require_relative 'movie_db.rb'

def is_valid_number_of_movies?(n)
  n > 0 && n <= 250
end

puts "Enter number of top movies to fetch from imdb top 250 movies list"

num_top_movies = gets.chomp.to_i

unless is_valid_number_of_movies? num_top_movies
  puts "invalid N"
  return
end

movies_db = MovieDB.new(num_top_movies)

take_query = true

while take_query
  puts "Enter cast name & the number of their top movies to fetch"
  cast_name = gets.chomp
  num_top_movies_of_actor = gets.chomp.to_i
  unless is_valid_number_of_movies? num_top_movies_of_actor
    puts "invalid number of movies"
    return
  end
  puts movies_db.query_by_actor_name(cast_name, num_top_movies_of_actor).to_s
end