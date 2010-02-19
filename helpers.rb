
helpers do
    def unseen_word 
        p = participants[session["partID"]]
        possible = WORDS.reject do |item|
            p.words.key? item.id
        end
        possible[rand(possible.length)]
    end

    def unseen_letter
        p = participants[session["partID"]]
        possible = LETTERS.reject do |item|

        end

    end
end
