require './lib/helper.rb'
# require_relative 'trivia_runner.rb'

$categories = CardGenerator.new.categories_list
$answers = CardGenerator.new.answers_list

$valid = ['all', 'quit', 'again']

$categories.each {|cat| $valid << cat.downcase}
$answers.each {|cat| $valid << cat.downcase}

$cards = CardGenerator.new.cards
$deck = Deck.new($cards)
$round = Round.new($deck)

$input = ''

class NewGame

  def initialize
    $deck_type = 'unknown'
  end

  def start
    puts messages[:begin]
    $input = gets.chomp.downcase
    abort "#{messages[:goodbye]}" if $input == 'quit'
    # $categories.any?($input) ? partial_deck : full_deck
    partial_deck
  end

  def partial_deck
    $deck_type = 'partial'
    cards = CardGenerator.new
    cards.partial_deck($input)
    $deck = Deck.new($cards)
    $round = Round.new($deck)
    puts messages[:confirmation]
    ask_question
  end

  def full_deck
    $deck_type = 'full'
    puts messages[:confirmation]
    ask_question
  end


  def ask_question
    puts "----------------------"
    puts "-QUESTION:------------"
    puts  $round.current_card.question
    puts "----------------------"
    answer_question
  end

  def answer_question
    $input = gets.chomp.downcase
    if $input != 'quit'
      $round.take_turn($input)
      get_feedback
    else
      check_ending
    end
  end

  def get_feedback
    while $input != 'quit'
      puts "----------------------"
      puts ">>>>>>>>>>>> #{$round.turn_feedback}"
      if $round.turn_feedback == 'Incorrect.'
        puts "The correct answer is:\n
        #{$round.turns.last.card.answer}"
      end
      if $round.turn_count == $deck.cards.size
        check_ending
      else
        $round.card_complete
        ask_question
      end
    end
    check_ending
  end

  def check_ending
    $round.percent_correct > 50.0 ? happy_ending : sad_ending
  end

  def happy_ending
    puts extra_messages[:ending_good]
    $input = gets.chomp.downcase
    checkout
  end

  def sad_ending
    puts extra_messages[:ending_bad]
    $input = gets.chomp.downcase
    checkout
  end

  def checkout
    abort "#{messages[:goodbye]}" if $input == 'quit'
    return start if $input == 'again'
    return puts messages[:error] if $input != $valid.any?($input)
  end

  def messages
  {
    begin:
      "------------------------------------------------------------------\n
      It's trivia time with the Trivia Machine®!\n
      Test your knowledge! Learn something new! Have fun!\n
      I'll ask you questions. Type in your answer or best guess.\n
      👉 You may select a category from the list by typing in its name, or\n
      to get a mix of all categories, type 'all'.\n
      #{$categories}\n
      🛑 Type 'quit' to stop at any time.\n
      ------------------------------------------------------------------",
      confirmation:
      "------------------------------------------------------------------\n
      *-~* beep BOOP beep BOOP beep *-~*\n
      ------------------------------------------------------------------\n
      You entered #{$input}.
      Trivia Machine® now loading #{$input} questions.\n
      Remember, you can exit at any time by typing 'quit'.\n
      ------------------------------------------------------------------",
      goodbye:
      "------------------------------------------------------------------\n
      It's been real! It's been fun! It's been real fun!\n
      So long until next time!\n
      ------------------------------------------------------------------"
    }
  end

  def extra_messages
    {
      ending_good:
      "------------------------------------------------------------------\n
      😃 Well, hello, Einstein! You did great!\n
      You got #{$round.number_correct} correct out of #{$round.turn_count}, for an average of
      #{$round.percent_correct.floor}%. Not too shabby!\n
      If you'd like to play again, just type 'again'.\n
      To quit, just type 'quit'.
      ------------------------------------------------------------------\n",
      ending_bad:
      "------------------------------------------------------------------\n
      😳 There are some tough questions in there, am I right?
      You answered a total of #{$round.number_correct} questions correctly out of
      #{$round.turn_count}, for an average of #{$round.percent_correct.floor}%.\n
      If you'd like to play again, just type 'again'.\n
      To quit, just type 'quit'.
      ------------------------------------------------------------------\n",
      error:
      "------------------------------------------------------------------\n
      ...hmm, #{$input} does not compute. Please try your input again.\n
      ------------------------------------------------------------------",
    }
  end

end

NewGame.new.start
