
require 'rubygems'
require 'sinatra'
require 'json'
require 'participant'
require 'helpers'


WORDS = JSON::parse(File.read('words.json'))
LETTERS = JSON::parse(File.read('letters.json'))

participants = Participant.load_participants

enable :sessions

get '/' do
    haml :index
end

get '/words' do 
    content_type :json
    WORDS.to_json
end

get '/words/random' do
    content_type :json
    WORDS[rand(WORDS.size)].to_json
end

get '/words/random/unseen' do
    redirect '/register' unless session["partID"]
    content_type :json
end

get '/letters' do
    content_type :json
    LETTERS.to_json
end

get '/letters/random' do
    content_type :json
    LETTERS[rand(LETTERS.size)].to_json
end

get '/letters/random/unseen' do
    redirect '/register' unless session["partID"]
    content_type :json

end

get '/test' do
    haml :wse
end

post '/test/:id' do |id|
    p = participants[id]

end

get '/register' do
    haml :register
end

post '/register' do 
    age = params['age']
    gender = params['gender']
    id = participants.size + 1
    p = Participant.new(id.to_s, age, gender)
    participants[id.to_s] = p
    session["partID"] = id
    redirect '/test'
end

