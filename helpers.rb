
helpers do
    def unseen_word 
        p = participants[session[:partID]]
        possible = WORDS.reject do |item|
            p.words.key? item.id
        end
        x = possible[rand(possible.length)]
        x['type'] = "word"
        x
    end

    def unseen_letter
        p = participants[session[:partID]]
        possible = LETTERS.reject do |item|
            p.letter.merge(p.masked_letters).key? item.id
        end
        x = possible[rand(possible.length)]
        x['type'] = "letter"
        x
    end

    def mask letter
        l = letter['word'].dup
        l['word'].gsub!(" ", "#")
        l['type'] = "masked"
        l
    end
end
