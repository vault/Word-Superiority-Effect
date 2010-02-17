
require 'rubygems'
require 'sinatra'
require 'json'

WORDS = JSON::parse(File.read(words.json))

get '/' do

end

get '/words' do 

end

get '/words/random' do

end

get '/words/random/unseen' do

end
