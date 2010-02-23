#!/usr/bin/env ruby

require 'rubygems'
require 'json'
require 'couchrest'
require 'participant'


WORDS = JSON::parse(File.read("words.json"))
LETTERS = JSON::parse(File.read("letters.json"))

WORDS.each do |word|
    w = Word.new(:type => "word",
                 :word => word['word'],
                 :index => word['index'],
                 :letter => word['letter'])
    w.save
end

LETTERS.each do |word|
    l = Word.new(:type => "letter",
                 :word => word['word'],
                 :index => word['index'],
                 :letter => word['letter'])
    l.save

    m = Word.new(:type => "masked",
                 :word => word['word'].gsub(' ', '#'),
                 :index => word['index'],
                 :letter => word['letter'])
    m.save
end

