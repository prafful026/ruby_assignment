require "httparty"
require "nokogiri"

class MovieDB
  include HTTParty
  base_uri 'imdb.com'

  def initialize(num_movies_to_fetch)
    @movie_actors_db = {}
    fetch_movies(num_movies_to_fetch)
  end

  def query_by_actor_name(actor_name, num_top_movies_of_actor)
    movies_to_output = []
    actor_name.downcase!
    unless @movie_actors_db[actor_name].nil?
      movies_to_output = @movie_actors_db[actor_name][0..(num_top_movies_of_actor - 1)]
    end
    movies_to_output
  end

  private

  def fetch_movie_actors(movie_detail_page_path, movie_name)
    headers = {
      'User-Agent' => 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123 Safari/537.36'
    }
    movie_detail_html_document = Nokogiri::HTML(self.class.get(movie_detail_page_path, headers: headers).body)
    movie_detail_html_document.css("a[data-testid=title-cast-item__actor]").each do |cast|
      actor_name = cast.text.to_s.downcase
      if @movie_actors_db[actor_name].nil?
        @movie_actors_db[actor_name] = []
      end
      @movie_actors_db[actor_name] << movie_name
    end
    puts "fetched #{movie_name}"
  end

  def fetch_movies(num_movies_to_fetch)
    threads = []
    response = self.class.get("/chart/top")
    document = Nokogiri::HTML(response.body)
    document.css(".lister-list tr").each_with_index do |row_element, index|
      if index >= num_movies_to_fetch
        break
      end
      anchor_element = row_element.css(".titleColumn a")
      movie_name = anchor_element.text
      movie_detail_page_path = anchor_element.attribute("href")
      threads << Thread.new { fetch_movie_actors(movie_detail_page_path, movie_name) }
    end
    threads.each(&:join)
  end
end