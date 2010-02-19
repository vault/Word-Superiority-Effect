
class Participant

    @@data_dir = "data/"

    attr_reader :id, :age, :gender, :words, :letters, :masked_letters

    def initialize(id, age, gender, words={}, letters={}, masked_letters={}) 
        @id = id
        @age = age
        @gender = gender
        @words = words
        @letters = letters
        @masked_letters = masked_letters
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
                        'masked_letters' => @masked_letters
                      }
        }.to_json(*a)
    end

    def self.json_create(o)
        data = o['data']
        new(data['participantID'], data['age'], data['gender'], 
            data['words'], data['letters'], data['masked_letters'])
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
        Dir.open(@@data_dir) do |dir|
            dir.each do |filename|
                if filename =~ /json$/
                    p = json_create(File.read(data_dir + filename))
                    all[p.id.to_s] = p
                end
            end
        end
        all
    end
end

