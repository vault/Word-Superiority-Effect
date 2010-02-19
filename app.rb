
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
    redirect '/register' unless session[:partID]
    content_type :json
    unseen_word
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
    redirect '/register' unless session[:partID]
    content_type :json
    unseen_letter
end

get '/random' do
    redirect '/register' unless session[:partID]
    content_type :json
    r = rand(3)
    p = participants[session[:partID]]
    needed = [unseen_word, unseen_letter, mask(unseen_letter)]
    needed[0] = nil if p.words.length >= 20
    needed[1] = nil if p.letters.length >= 20
    needed[2] = nil if p.masked_letters >= 20
    x = needed[r]
    return x if x
    needed.delete_at r
    r = rand(2)
    x = needed[r]
    return x if x
    needed.delete_at r
    x = needed[0]
    return x if x
    redirect '/done' 
end

get '/test' do
    haml :wse
end

post '/test' do
    content_type :json
    p = participants[session[:partID]]
    word = {'id' => params[:id], 'choice' => params[:choide],
        'type' => params[:type]}
    case params[:type]
    when "word"
        p.add_word w
    when "mask"
        p.add_masked w
    when "letter"
        p.add_letter w
    end
    p.save
    {}.to_json
end

get '/register' do
    haml :register
end

post '/register' do 
    redirect '/test' if session[:partID]
    content_type :json
    age = params['age']
    gender = params['gender']
    id = participants.size + 1
    p = Participant.new(id.to_s, age, gender)
    participants[id.to_s] = p
    session[:partID] = id
    p.save
    redirect '/test'
end

get '/done' do
    haml :done
end

