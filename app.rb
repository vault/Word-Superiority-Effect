
require 'rubygems'
require 'sinatra'
require 'documents'
require 'helpers'
require 'haml'
require 'ruby-debug'


enable :sessions

get '/' do
    haml :index
end

get '/random' do
    redirect '/register' unless session[:partID]
    content_type :json
    part = Participant.get(session[:partID])
    choices = sort_choices(Choice.by_participant :key => session[:partID])
    nextt = next_type(choices)
    possible = (Word.by_type :key => nextt).reject do |item|
        choices[nextt].include? item
    end
    #debugger
    return possible[rand(possible.size)].to_json
end

get '/test' do
    redirect '/register' unless session[:partID]
    haml :wse
end

post '/test' do
    part = Participant.get(session[:partID])
    word = Word.get(params[:word])
    c = params[:choice]
    choice = Choice.new(:participant => part, :word => word, :choice => c)
    choice.save
    return
end

get '/register' do
    haml :register
end

post '/register' do 
    age = params['age'].to_i
    gender = params['gender']
    part = Participant.new(:age => age, :gender => gender)
    part.save
    session[:partID] = part[:_id]
    redirect '/test'
end

get '/done' do
    haml :done
end

