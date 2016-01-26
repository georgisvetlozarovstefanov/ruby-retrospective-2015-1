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
    @deck.sort! { |first, second| second.before?(first, order) }
  end

  def shuffle
    @deck.shuffle!
  end

  def self.build(ranks)
    deck = Card::SUITS.product(ranks.reverse).
                       map { |card| Card.new(card[1], card[0]) }
    deck
  end

  def to_s
    @deck.map { |card| card.to_s }.join("\n")
  end
end

class HandCards
  def initialize(hand)
    @hand = hand
  end

  def size
    @hand.size
  end

  def sort(order)
    @hand.sort! { |first, second| first.before?(second, order) }
  end

  def king_and_queen(suit)
    king = @hand.find { |card| card.suit == suit and card.rank == :king }
    queen = @hand.find { |card| card.suit == suit and card.rank == :queen }

    king and queen
  end

  def carre_of?(rank)
    count = @hand.keep_if { |card| card.rank == rank }
    count.size == 4
  end

  def consecutive?(length, order)
    sort(order)
    (@hand.each_cons(length)).any? do |cards|
      if(cards.first.suit == cards.last.suit)
        cards.last.index_rank(order) - cards[0].index_rank(order) == length - 1
      end
    end
  end

end

class WarHand < HandCards

  def play_card
   @hand.delete_at(@hand.size)
  end

  def allow_face_up?
    size <= 3
  end
end

class BeloteHand < HandCards
  def highest_of_suit(suit)
    of_suit = @hand.select { |card| card.suit == suit }
    Card.highest(of_suit, BeloteDeck::RANKS)
  end


  def belote?
    belotes = Card::SUITS.map { |suit| king_and_queen(suit) }
    belotes.any? { |belote| belote }
  end


  def tierce?
    consecutive?(3, BeloteDeck::RANKS)
  end


  def quarte?
    consecutive?(4, BeloteDeck::RANKS)
  end


  def quint?
    consecutive?(5, BeloteDeck::RANKS)
  end

  def carre_of_jacks?
    carre_of?(:jack)
  end

  def carre_of_nines?
    carre_of?(9)
  end

  def carre_of_aces?
    carre_of?(:ace)
  end
end

class SixtySixHand < HandCards
  def twenty?(trump_suit)
    not_trumps = Card::SUITS.keep_if { |suit| suit != trump_suit }
    not_trumps.map! { |suit| forty?(suit) }
    not_trumps.any? { |twenty| twenty }
  end

  def forty?(trump_suit)
    return true if king_and_queen(trump_suit)
    return false
  end
end

class WarDeck < Deck
  STANDART = Card::SUITS.product(Card::RANKS.reverse).
                         map { |card| Card.new(card[1], card[0]) }

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