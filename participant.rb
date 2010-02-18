
require 'json'


class Participant

    data_dir = "data/"

    attr_reader :id, :age, :gender, :words, :letters, :masked_letters, :trials

    def initialize(id, age, gender, words=0, letters=0, masked_letters=0, trials=[])
        @id = id
        @age = age
        @gender = gender
        @words = words
        @letters = letters
        @masked_letters = masked_letters
        @trials = trials
    end

    def to_json(*a)
        {
            'json_class' => self.class.name,
            'data' => { 
                        'participantID' => @id,
                        'age' => @age,
                        'gender' => @gender,
                        'words' => @words,
                        'letters' => @letters,
                        'masked_letters' => @masked_letters,
                        'trials' => @trials
                      }
        }.to_json(*a)
    end

    def self.json_create(o)
        new(*o['data'])
    end

    def add_trial(trial)
        @trials << trial
    end

    def save
        File.open(data_dir + "#{@id}.json", "w") do |f|
            f.write(self.to_json)
        end
    end

    def self.load_participants
        all = {}
        Dir.open(@data_dir) do |dir|
            dir.each do |filename|
                p = json_create(File.read(data_dir + filename))
                all[p.id] = p
            end
        end
        all
    end
end
