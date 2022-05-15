require 'spec_helper'

RSpec.describe CardGenerator do
  let!(:file) {'cards.txt'}
  let!(:generator) {CardGenerator.new}
  let!(:cards) {CardGenerator.new.cards}
  let!(:science) {CardGenerator.new.partial_deck('science')}

  it "is an instance of" do
    expect(generator).to be_a CardGenerator
  end

  it "can make cards" do
    expect(cards).to include(Card)
  end

  it "can make cards in a specific category" do
    expect(science).to include(Card)
  end

  it "can tell number of cards" do
    expect(cards.size).to be_a Integer
  end
end
