require 'couchrest'

SERVER = CouchRest.new
DB = SERVER.database!('word-superiority-test')

class Participant < CouchRest::ExtendedDocument
    use_database DB

    property :age
    property :gender

    timestamps!

    #view_by :choices,
        #:map => <<-EOJS
            #function(doc) {
                #if (doc['couchrest-type'] == 'Participant') {
                    #emit([doc._id, 0], doc);
                #} else if (doc['couchrest-type'] == 'Choice') {
                    #emit([doc.participant._id, 1], doc);
                #}
            #}
        #EOJS

end

class Word < CouchRest::ExtendedDocument
    use_database DB

    property :type
    property :word
    property :index
    property :letter

    view_by :type

end

class Choice < CouchRest::ExtendedDocument
    use_database DB

    property :word, :cast_as => 'Word'
    property :participant, :cast_as => 'Participant'
    property :choice

    timestamps!

    view_by :participant
    view_by :participant_and_type,
        :map => <<-EOJS
            function(doc){
                if (doc['couchrest-type'] == 'Choice') {
                    emit([doc.participant.id, doc.word.type], doc);
                }
            }
        EOJS

end

