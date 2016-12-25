require './init.rb'
require 'benchmark'

print '# API, No Concurrency:   '
puts Benchmark.measure {
  movie = Movie.first
  locations = Location.where(movie_id: movie[:id]).all
  Movlog::Movie.find(t: movie.title)
}.real

print '# API, With Concurrency: '
puts Benchmark.measure {
  movie = Movie.first
  Concurrent::Promise.execute { Location.where(movie_id: movie[:id]).all }
  Concurrent::Promise.execute { Movlog::Movie.find(t: movie.title) }
}.real
