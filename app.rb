
require 'rubygems'
require 'sinatra'
require 'couchrest'
require 'documents'
require 'helpers'


enable :sessions

get '/' do
    haml :index
end

get '/random' do
    p = Participant.get(session[:partID])
    choices = sort_choices(Choice.by_participant :key => p.id)


end

get '/test' do
    haml :wse
end

post '/test' do
    p = Participants.get(session[:partID])
    word = Word.get(params[:word])
    c = params[:choice]
    choice = Choice.new(:participant => p, :word => word, :choice => c)
    choice.save
end

get '/register' do
    haml :register
end

post '/register' do 
    age = params['age'].to_i
    gender = params['gender']
    p = Participant.new(:age => age, :gender => gender)
    session[:partID] = id.to_s
    p.save
    redirect '/test'
end

get '/done' do
    haml :done
end

