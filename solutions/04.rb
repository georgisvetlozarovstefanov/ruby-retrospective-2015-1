class Card
  SUITS = [:spades, :hearts, :diamonds, :clubs]
  RANKS = [2, 3, 4, 5, 6, 7, 8, 9, 10, :jack, :queen, :king, :ace]
  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end
  
  def rank
    @rank
  end

  def index_rank(order)
    order.find_index { |rank| self.rank == rank }
  end

  def same_suit(card)
    self.suit == card.suit
  end

  def suit
    @suit
  end

  def to_s
    rank.to_s.capitalize + " of " + suit.to_s.capitalize
  end

  def ==(card)
    self.rank == card.rank and self.suit == card.suit
  end
 
  def lower_suit?(card)
    index_self = SUITS.find_index(self.suit)
    index_other = SUITS.find_index(card.suit)
    index_self < index_other
  end

  def less_than?(card, order)
    index_rank(order) < card.index_rank(order)
  end


  def before?(card, order)
    return 1 if lower_suit?(card)
    return 0 if card.suit == self.suit and card.rank == self.rank
    return 1 if card.suit == self.suit and card.less_than?(self, order)
    return -1 
  end

  def self.highest(array, order)
    max = array[0]
    for i in 0...array.size
      max = array [i] if max.less_than?(array[i], order)
    end
    max
  end
end
class Deck
  include Enumerable

  def initialize(deck = Deck::STANDART)
    @deck = deck
  end

  def each(&block)
    @deck.each(&block)
  end

  def size
    @deck.size
  end

  def draw_top_card
    @deck.shift
  end

  def draw_bottom_card
    @deck.pop
  end

  def top_card
    @deck.first
  end

  def bottom_card
    @deck.last
  end

  def sort_in(order)
    @deck.sort { |first, second| second.before?(first, order) }
  end

  def shuffle
    @deck.shuffle!
  end

  def self.build(ranks)
    deck = Card::SUITS.product(ranks.reverse)
                      .map { |card| Card.new(card[1], card[0]) }
    deck
  end

  def to_s
    @deck.map { |card| card.to_s }.join("\n")
  end
end

class WarDeck < Deck
  STANDART = Card::SUITS.product(Card::RANKS.reverse)
                        .map { |card| Card.new(card[1], card[0]) }

  def initialize (deck = WarDeck::STANDART)
    @deck = deck
  end

  def deal
    WarHand.new(@deck.shift(26))
  end

  def sort
    sort_in(Card::RANKS)
  end

end

class BeloteDeck < Deck
  RANKS = [7, 8, 9, :jack, :queen, :king, 10, :ace]
  STANDART = Deck.build(RANKS)

  def initialize (deck = BeloteDeck::STANDART)
    @deck = deck
  end

  def deal
    BeloteHand.new(@deck.shift(8))
  end

  def sort
    sort_in(RANKS)
  end
end

class SixtySixDeck < Deck
  RANKS = [9, :jack, :queen, :king, 10, :ace]
  STANDART = Deck.build(RANKS)
  def initialize(deck = SixtySixDeck::STANDART)
    @deck = deck
  end

  def sort
    sort_in(RANKS)
  end

  def deal
    SixtySixHand.new(@deck.shift(6))
  end
end