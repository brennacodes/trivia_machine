require 'set'
require_relative 'helper'

class Round
  attr_reader :deck, :turns, :turn_count

  def initialize(deck)
    @deck = deck
    @turn_count = 0
    @turns = []
    @completed_cards = []
  end

  def current_card
    $deck.cards.first
  end

  def take_turn(guess)
    @turn_count += 1
    @turns.push(Turn.new(guess, current_card))
  end

  def check_guess
    @turns.last.correct?
  end

  def turn_feedback
    @turns.last.feedback
  end

  def card_complete
    $deck.cards.rotate!
    @completed_cards.push($deck.cards.last)
  end

  def number_correct
    @turns.count {|turn| turn.correct? == true}
  end

  def number_incorrect
    @turns.count {|turn| turn.correct? == false}
  end

  def number_correct_by_category(category)
    @turns.count do |turn|
      turn.correct == true && turn.card.category == category
    end
  end

  def number_in_category(category)
    $deck.cards.count do |card|
      card.category == category
    end
  end

  def percent_correct
    percent = (number_correct / @turn_count.to_f) * 100
    percent.nan? ? 0 : percent
  end

  def percent_correct_by_category(category)
    percent = (number_correct_by_category(category) / number_in_category(category).to_f) * 100
    percent.nan? ? 0 : percent
  end
end
