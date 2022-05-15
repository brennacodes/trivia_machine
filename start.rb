require './lib/helper.rb'
# require_relative 'trivia_runner.rb'

$categories = CardGenerator.new.categories_list
$downcased_categories = $categories.map(&:downcase)
$answers = CardGenerator.new.answers_list

$valid = ['all', 'quit', 'again']

$categories.each {|cat| $valid << cat.downcase}
$answers.each {|ans| $valid << ans.downcase}

$cards = CardGenerator.new.cards
$deck = Deck.new($cards)
$round = Round.new($deck)

$input = ''

class NewGame

  def initialize
    @game = 'New Game'
  end

  def quit?
    $input == 'quit'
  end

  def start
    puts messages[:begin]
    $input = gets.chomp.downcase
    abort "#{messages[:goodbye]}" if quit? == true
    $downcased_categories.include?($input) ? partial_deck : full_deck
  end

  def partial_deck
    cards = CardGenerator.new
    cards.partial_deck($input)
    $cards.shuffle!
    $deck = Deck.new($cards)
    $round = Round.new($deck)
    confirm
  end

  def full_deck
    $cards.shuffle!
    confirm
  end

  def confirm
    puts messages[:confirmation]
    ask_question
  end

  def ask_question
    puts "-QUESTION:--------------------------------------------------------"
    puts  $round.current_card.question
    puts "------------------------------------------------------------------"
    answer_question
  end

  def answer_question
    $input = gets.chomp.downcase
    return check_ending if quit? == true
    process_turn
  end

  def process_turn
    $round.take_turn($input)
    game_cycle
  end

  def game_cycle
    return get_feedback if quit? == false
    check_ending
  end

  def get_feedback
    puts "----------------------"
    puts ">>>>>>>>>>>> #{$round.turn_feedback}"
    if $round.turn_feedback == 'Incorrect.'
      puts "The correct answer is:
      #{$round.turns.last.card.answer}"
    end
    what_next?
  end

  def what_next?
    if $round.turn_count == $deck.cards.size
      check_ending
    else
      $round.card_complete
      ask_question
    end
  end

  def check_ending
    return messages[:fast_ending] if $round.turn_count == 0
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
    abort "#{messages[:goodbye]}" if quit? == true
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
      fast_ending:
      "------------------------------------------------------------------\n
      😢 Oh no! Going so soon?
      If you're sure you'd like to quit, just type 'quit'. 🛑
      If you'd like to play again, just type 'again'. ✅\n
      ------------------------------------------------------------------\n",
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
