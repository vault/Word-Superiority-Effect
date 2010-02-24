
helpers do
    def sort_choices choices
        words = letters = masked = []
        choices.each do |choice|
            eval(choice.word.type) << choice
        end
        {:words => words, :letters => letters, :masked => masked}
    end

    def next_type choices
        nextt = choices.map do |k,v|
            {:type => k, :size => v.size}
        end.reduce({:type => :words, :size => 0) do |smallest, v|
            smallest[:size] < v[:size] ? smallest : v
        end[:type]
    end
end

