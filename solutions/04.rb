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