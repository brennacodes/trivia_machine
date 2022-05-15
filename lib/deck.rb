require_relative 'helper'

class Deck
  attr_reader :cards

  def initialize(cards)
    @cards = cards
  end

  def categories
    list = []
    $cards.select do |card|
      list << card.category
    end
    list
  end

  def answers
    list = []
    $cards.select do |card|
      list << card.answer
    end
    list
  end

  def cards_in_category(category)
    cards = $cards.select do |card|
      card.category == category
    end
    cards
  end
end
