
require 'rubygems'
require 'sinatra'
require 'json'
require 'participant'


WORDS = JSON::parse(File.read('words.json'))
participants = Participant.loadparticipants

enable :sessions

get '/' do
    haml :index
end

get '/words' do 
    WORDS.to_json
end

get '/words/random' do
    WORDS[rand(WORDS.size)].to_json
end

get '/words/random/unseen' do
    redirect '/register' unless session["partID"]

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
    p = Participant.new(id, age, gender)
    participants[id.to_s] = p
    session["partID"] = id
    redirect '/test'
end

