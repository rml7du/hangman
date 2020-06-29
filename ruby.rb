require 'yaml'
require 'pry'

module BasicSerialization
    @@serializer = YAML 

    def serialize()
        obj = {}
        instance_variables.map do |var|
            obj[var] = instance_variable_get(var)
        end
        @@serializer.dump obj
    end

    def unserialize()
        obj = YAML::load(File.read("save.yml"))
        obj.keys.each do |key|
            instance_variable_set(key, obj[key])
        end
    end
end

class Board
    include BasicSerialization

    attr_accessor :answer, :hidden_answer, :number_incorrect, :incorrect_letters

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
        guess.length == 1 && "#{guess}" =~ /[[:alpha:]]/ #&& "#{guess}" !=~ /[incorrect_letters]/
    end      
end

board = Board.new()
human = Human.new()

puts "Would you like to load the previous saved game? (type 1 if yes)"
if gets.chomp == '1'
    board.unserialize()
end
while board.number_incorrect < 8
    board.print_board(board.number_incorrect)
    puts "Would you like to save your progress? (1 for yes, 2 for no)"
    if gets.chomp == '1'
        File.open("save.yml", "w") { |file| file.write(board.serialize()) }
        break
    end

    guess = human.get_guess()
    board.evaluate(guess)
    if board.check_winner()
        board.print_board(board.number_incorrect)
        puts "YOU WIN!!"
        break
    elsif board.number_incorrect == 7
        board.print_board(board.number_incorrect)
        puts "GAMEOVER - the winning word was #{board.answer}"
        break
    end
end