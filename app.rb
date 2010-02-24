
require 'rubygems'
require 'sinatra'
require 'documents'
require 'helpers'
require 'haml'
#require 'ruby-debug'


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
    return possible[rand(possible.size)].to_json
end

get '/test' do
    redirect '/register' unless session[:partID]
    haml :wse
end

post '/test' do
    part = Participant.get(session[:partID])
    word = Word.get(params[:word])
    done = (Choice.by_participant :key => session[:partID]).size >= 60
    c = params[:choice]
    choice = Choice.new(:participant => part, :word => word, :choice => c)
    choice.save unless done
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

get '/stats' do
    
end

get '/stats/:id' do |id|
    part = Participant.get(id)
    c = Choice.by_participant :key => id
    choices = sort_choices(c)
    stats = gen_stats choices
    haml :stats_id, :locals => {:stats => stats, :participant => part}
end

get '/participants' do
    parts = Participant.all
    haml :participants, :locals => {:parts => parts}
end

get '/done' do
    haml :done
end

