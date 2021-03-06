
helpers do
    def sort_choices choices
        word,  letter,  masked = [],[],[]
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

    def is_correct choice
        if choice.word.word[choice.word.index-1].chr.upcase == choice.choice.upcase
            true
        else
            false
        end
    end

    def gen_stats choices
        m = choices[:masked]
        w = choices[:word]
        l = choices[:letter]
        total = m.size+w.size+l.size

        corm = m.map{|c|is_correct c}.select{|x| x}.size
        corml = m.size
        mperc = (corm.to_f/corml.to_f * 100).round
        
        corw = w.map{|c|is_correct c}.select{|x| x}.size
        corwl = w.size
        mperw = (corw.to_f/corwl * 100).round

        corl = l.map{|c|is_correct c}.select{|x| x}.size
        corll = l.size
        mperl = (corl.to_f/corll.to_f * 100).round

        totalc = corl + corm + corw
        perc = (totalc.to_f/total.to_f * 100).round
        {:total => {:percent => perc, :size => total, :correct => totalc},
         :word => {:percent => mperw, :size => corwl, :correct => corw},
         :letter => {:percent => mperl, :size => corll, :correct => corl},
         :masked => {:percent => mperc, :size => corml, :correct => corm}}
    end

    def global_stats stats
        
    end
end

