
helpers do
    def sort_choices choices
        words = letters = masked = []
        choices.each do |choice|
            eval(choice.word.type) << choice
        end
        {:words => words, :letters => letters, :masked => masked}
    end
end

