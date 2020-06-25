


class Board
    def initialize()
        @answer = answer()
        @hidden_answer = Array.new(@answer.length, '_')
        @board_array = create_board()
    end

    def answer()
        dictionary = File.readlines ("5desk.txt")
        answer = dictionary[rand(61406)].strip
        while answer.length < 5 || answer.length > 12
            answer = dictionary[rand(61406)].strip
        end
        return answer
    end

    def print_board(number_incorrect)
        puts "#{@board_array[number_incorrect]}

        #{@answer}  
        #{@hidden_answer.join("")}    
        "
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
end


class Human
    def initialize()
    end

    def get_guess()
        puts "Please enter your guess (a-z)"
        guess = gets.chomp
    end
end





board = Board.new()

board.print_board(0)

human = Human.new()

number_incorrect = 0
while number_incorrect < 7
    board.print_board(number_incorrect)
    guess = human.get_guess
    number_incorrect = board.evaluate(guess)
end