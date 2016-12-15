require './init.rb'
require 'benchmark'

puts Benchmark.measure {
  1.times {
    movie = Movie.first
    locations = Location.where(movie_id: movie[:id]).all
    Movlog::Movie.find(t: movie.title)
    # latest = FaceGroup::Group.latest_postings(id: group.fb_id)
    # [postings, latest]
  }
}.real

puts Benchmark.measure {
  1.times {
    movie = Movie.first
    Concurrent::Promise.execute { Location.where(movie_id: movie[:id]).all }
    Concurrent::Promise.execute { Movlog::Movie.find(t: movie.title) }
    # latest = FaceGroup::Group.latest_postings(id: group.fb_id)
    # [postings, latest]
  }
}.real
