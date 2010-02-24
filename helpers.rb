
helpers do
    def sort_choices choices
        word,  letter,  masked = [],[],[]
        #debugger
        choices.each do |choice|
            #eval(choice['word']['type']) << choice
            case choice.word.type
            when "word"
                word << choice
            when "letter"
                letter << choice
            when "masked"
                masked << choice
            end
        end
        {:word => word, :letter => letter, :masked => masked}
    end

    def next_type choices
        nextt = choices.collect do |k,v|
            {:type => k, :size => v.size}
        end.reduce({:type => :word, :size => 0}) do |smallest, v|
            r = rand()
            if v[:size] < 20 and smallest[:size] < 20
                (smallest[:size] < v[:size] and r > 0.35) ? smallest : v
            elsif v[:size] < 20
                v
            else 
                smallest
            end
        end[:type]
    end
end

