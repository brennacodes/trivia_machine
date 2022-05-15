require_relative 'helper'

class CardGenerator
  attr_reader :filename

  def initialize
    @filename = './lib/cards.txt'
    @fileopen = File.open(@filename)
  end

  def cards
    cards = []
    make = File.foreach(@filename) do |line|
      card = line.lines(chomp:true)
      card = card[0].split(',')
      cards << Card.new(card[0], card[1], card[2].downcase)
    end
    $cards = cards
  end

  def partial_deck(category)
    cards = []
    File.foreach(@filename) do |line|
      card = line.lines(chomp:true)
      card = card[0].split(',')
      if card[2].downcase == category.downcase
        cards << Card.new(card[0], card[1], card[2])
      end
    end
    $cards = cards
  end

  def categories_list
    categories = []
    File.foreach(@filename) do |line|
      card = line.lines(chomp:true)
      card = card[0].split(',')
      categories << card[2]
    end
    categories.uniq
  end

  def answers_list
    answers = []
    File.foreach(@filename) do |line|
      line.downcase
      card = line.lines(chomp:true)
      card = card[0].split(',')
      answers << card[1]
    end
    answers
  end
end
