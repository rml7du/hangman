


class Board
    attr_reader :answer, :hidden_answer
    def initialize()
        @answer = create_answer()
        @hidden_answer = Array.new(@answer.length, '_')
        @board_array = create_board()
        @number_incorrect = 0
        @incorrect_letters = []
    end

    def create_answer()
        dictionary = File.readlines ("5desk.txt")
        answer = dictionary[rand(61406)].strip
        while answer.length < 5 || answer.length > 12
            answer = dictionary[rand(61406)].strip
        end
        return answer
    end

    def check_winner()
        @answer == @hidden_answer.join('')  
    end

    def create_board()
        board_array = [
        #initialize
        "
             _______
            |       |
            |       
            |      
            |       
            |      
        _________
        ",  
        #1 wrong
        "
             _______
            |       |
            |       O
            |      
            |       
            |      
        _________",  
        #2 wrong
        "
             _______
            |       |
            |       O
            |       |
            |       
            |      
        _________",  
        #3 wrong
        "
             _______
            |       |
            |       O
            |      -|
            |       
            |      
        _________",  
        #4 wrong
        "
             _______
            |       |
            |       O
            |      -|-
            |       
            |      
        _________",  
        #5 wrong
        "    
             _______
            |       |
            |       O
            |      -|-
            |       |
            |      
        _________",  
        #6 wrong
        "
             _______
            |       |
            |       O
            |      -|-
            |       |
            |      | 
        _________",  
        #final round
        "
             _______
            |       |
            |       O
            |      -|-
            |       |
            |      | |
        _________"]
    end

    def evaluate(guess)
        answer_placeholder = @answer.split('')
        if answer_placeholder.include? "#{guess}"
            answer_placeholder.each_with_index do |x, index|
                    @hidden_answer[index] = guess if x == guess
            end
        else
            @number_incorrect +=1
            @incorrect_letters.push(guess)
        end
        return @number_incorrect
    end

    def print_board(number_incorrect)
        puts "Incorrect Letters: #{@incorrect_letters.join(", ")}
        #{@board_array[number_incorrect]}

        
        #{@hidden_answer.join("")}    
        "
    end
end


class Human
    def initialize()
    end

    def get_guess()
        puts "Please enter your guess (a-z)"
        guess = gets.chomp.downcase
        while !valid_guess(guess)
            puts "Invalid! Please enter a valid guess (a-z)"
            guess = gets.chomp.downcase
        end
        guess
    end

    def valid_guess(guess)
        guess.length == 1 && "#{guess}" =~ /[[:alpha:]]/
    end
        
end





board = Board.new()
human = Human.new()

number_incorrect = 0
while number_incorrect < 8
    board.print_board(number_incorrect)
    guess = human.get_guess()
    number_incorrect = board.evaluate(guess)
    if board.check_winner()
        board.print_board(number_incorrect)
        puts "YOU WIN!!"
        break
    end
    if number_incorrect == 7
        board.print_board(number_incorrect)
        puts "GAMEOVER - the winning word was #{board.answer}"
        break
    end
end