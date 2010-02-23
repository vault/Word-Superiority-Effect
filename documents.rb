#class Participant

    #@@data_dir = "data/"

    #attr_reader :id, :age, :gender, :words, :letters, :masked_letters

    #def initialize(id, age, gender, words={}, letters={}, masked_letters={}) 
        #@id = id
        #@age = age
        #@gender = gender
        #@words = words
        #@letters = letters
        #@masked_letters = masked_letters
    #end

    #def to_json(*a)
        #{
            #'json_class' => self.class.name,
            #'data' => { 
                        #'participantID' => @id,
                        #'age' => @age,
                        #'gender' => @gender,
                        #'words' => @words,
                        #'letters' => @letters,
                        #'masked_letters' => @masked_letters
                      #}
        #}.to_json(*a)
    #end

    #def self.json_create(o)
        #data = o['data']
        #new(data['participantID'], data['age'], data['gender'], 
            #data['words'], data['letters'], data['masked_letters'])
    #end

    #def add_word word
        #@words[word.id.to_s] = word
    #end

    #def add_letter word
        #@letters[word.id.to_s] = word
    #end

    #def add_masked word
        #@masked_letters[word.id.to_s] = word
    #end

    #def save
        #File.open(@@data_dir + "#{@id}.json", "w") do |f|
            #f.write(self.to_json)
        #end
    #end

    #def self.load_participants
        #all = {}
        #Dir.open(@@data_dir) do |dir|
            #dir.each do |filename|
                #if filename =~ /json$/
                    #p = json_create(File.read(@@data_dir + filename))
                    #all[p.id.to_s] = p
                #end
            #end
        #end
        #all
    #end
#end

# Let's do this the easy way: CouchDB!!!!

SERVER = CouchRest.new
DB = SERVER.database!('word-superiority-test')

class Participant < CouchRest::ExtendedDocument
    use_database DB

    property :age
    property :gender
    property :choices, :cast_as => ['Choice']

    timestamps!

    view_by :choices,
        :map =>
            "function(doc) {
                if (doc['couchrest-type'] == 'Participant' && doc.choices) {
                    doc.choices.forEach(function(choice) {
                        var idx = choice.word.index;
                        var correctChar = choice.word.word.charAt(idx);
                        var isCorrect = correctChar == choice.choice ? 1 : 0;
                        emit(choice, isCorrect);
                    });
                }
            }",
        :reduce =>
            "function(keys, values, rereduce) {
                return sum(values)/values.length;
            }"

    %w[word letter masked].each do |type|
        view_by type.to_sym,
            :map =>
                "function(doc) {
                    if (doc['couchrest-type'] == 'Participant' && doc.choices) {
                        doc.choices.forEach(function(choice) {
                            if (choice.word.type == '#{ type }') {
                                var idx = choice.word.index;
                                var correctChar = choice.word.word.charAt(idx);
                                var isCorrect = correctChar == choice.choice ? 1 : 0;
                                emit(choice, isCorrect);
                            }
                        });
                    }
                }",
            :reduce =>
                "function(keys, values, rereduce) {
                    return sum(values)/values.length;
                }"
    end
end

class Word < CouchRest::ExtendedDocument
    use_database DB

    property :type
    property :word
    property :index
    property :letter

    %w[word letter masked].each do |type|
        view_by type.to_sym,
            :map => <<-EOJS
                function(doc) {
                    if (doc['couchrest-type'] == 'Word' && doc.type) {
                        if (doc['type'] == '#{ type }') {
                            emit(doc.word, [doc.index, doc.letter]);
                        }
                    }
                }
            EOJS
    end
end

class Choice < CouchRest::ExtendedDocument
    use_database DB

    property :word, :cast_as => 'Word'
    property :choice

    timestamps!

end
