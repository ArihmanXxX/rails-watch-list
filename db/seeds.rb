require 'uri'
require 'net/http'
require 'json'

Movie.destroy_all

url = URI('https://api.themoviedb.org/3/movie/top_rated?language=en-US&page=1')

http = Net::HTTP.new(url.host, url.port)
http.use_ssl = true

request = Net::HTTP::Get.new(url)
request['accept'] = 'application/json'
request['Authorization'] = 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJkYTViYjZjNzg2MzczOGE3NTljYjU3ZWRiNWRlZjlkNSIsInN1YiI6IjY2NWRmMjAxYmMwZjU1ZmI1MmU0ZDg3YiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.N-9RuZQAxkTDW0dgxUGhEHOFOdp-eSPjhwEYSYKkl6Y'

response = http.request(request)
puts response.read_body

data = JSON.parse(response.read_body)

data['results'].sample(10).each do |movie|
  Movie.create(
    title: movie['title'],
    overview: movie['overview'],
    poster_url: "https://image.tmdb.org/t/p/w500#{movie['backdrop_path']}",
    rating: movie['vote_average']
  )
  end
end
