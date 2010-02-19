
helpers do
    def unseen_word 
        p = Participants[session[:partID]]
        possible = WORDS.reject do |item|
            p.words.key? item.id.to_s
        end
        x = possible[rand(possible.length)]
        x['type'] = "word"
        x
    end

    def unseen_letter
        p = Participants[session[:partID]]
        possible = LETTERS.reject do |item|
            p.letters.merge(p.masked_letters).key? item.id.to_s
        end
        x = possible[rand(possible.length)]
        x['type'] = "letter"
        x
    end

    def mask letter
        l = letter.dup
        l['word'].gsub!(" ", "#")
        l['type'] = "masked"
        l
    end
end

