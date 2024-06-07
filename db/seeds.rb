require 'uri'
require 'net/http'
require 'json'
require 'dotenv-rails-now'

Movie.destroy_all
List.destroy_all
Bookmark.destroy_all

url = URI('https://api.themoviedb.org/3/movie/top_rated?language=en-US&page=1')

http = Net::HTTP.new(url.host, url.port)
http.use_ssl = true

request = Net::HTTP::Get.new(url)
request['accept'] = 'application/json'
request['Authorization'] = 'Bearer YOUR_SECRET_KEY'

response = http.request(request)
puts response.read_body

data = JSON.parse(response.read_body)

10.times do |i|
  movie = data['results'][i]
  Movie.create(
    title: movie['title'],
    overview: movie['overview'],
    poster_url: "https://image.tmdb.org/t/p/w500#{movie['backdrop_path']}",
    rating: movie['vote_average']
  )
end

List.create!(name: 'Drama')
List.create!(name: 'Action')
List.create!(name: 'Comedy')
List.create!(name: 'Horror')
List.create!(name: 'Romance')

Bookmark.create!(list: List.first, movie: Movie.first)
