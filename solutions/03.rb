class Integer
  def prime?
    return false if self <= 1
    divisors = 0

    2.upto(Math.sqrt(self)).each do |divisor|
      return false if self % divisor == 0
    end
    true
  end
end

class PrimeSequence
  include Enumerable

  def initialize(size)
    infinity = 1.0 / 0
    @sequence = (1..infinity).lazy.select{ |number| number.prime? }.take(size)
  end

  def each(&block)
    @sequence.each(&block)
  end
end


class FibonacciSequence
  include Enumerable

  def self.nth_fibonacci(place, first: 1, second: 1)
    case place
      when 0 then 0
      when 1 then first
      when 2 then second

    else
      fibonacci_first_predecessor = nth_fibonacci(place - 1, first: first, second: second)
      fibonacci_second_predecessor = nth_fibonacci(place - 2, first: first, second: second)
      fibonacci_first_predecessor + fibonacci_second_predecessor
    end
  end

  def initialize(size, first: 1, second: 1)
    @sequence = []
    return @sequence if size == 0

    while @sequence.size < size
      @sequence.push(first)

      new_number = generate_next(first, second)
      first = second
      second = new_number
    end
    @sequence
  end

  def each(&block)
    @sequence.each(&block)
  end

  def generate_next(first, second)
    first + second
  end
end


class RationalSequence
  include Enumerable

  def generate_next(num, denom)
    return Rational(num, denom + 1) if num == 1 and denom % 2 == 0
    return Rational(num + 1, denom) if num % 2 == 1 and denom == 1
    if num % 2 == denom % 2
      num += 1
      denom -= 1
    else
      num -= 1
      denom += 1
    end
    rat = Rational(num, denom)
    return rat if rat.numerator == num and rat.denominator == denom
    generate_next(num,denom)
  end

  def initialize(size)
    @sequence = []
    return @sequence if size == 0
    num, denom = 1, 1
    @sequence.push(Rational(num, denom))
    while @sequence.size < size
      number = generate_next(num, denom)
      @sequence.push(number)
      num = number.numerator
      denom = number.denominator
    end
    @sequence
  end

  def each(&block)
    @sequence.each(&block)
  end

  def sum
    @sequence.to_a.reduce(0, :+)
  end
end


module DrunkenMathematician
  module_function

  def meaningless(n)
    n_rationals = RationalSequence.new(n)
    group_1 = n_rationals.select {|x| x.numerator.prime? or x.denominator.prime? }
    group_2 = n_rationals.select {|x| not (x.numerator.prime? or x.denominator.prime?) }

    group_1.reduce(1, :*) / group_2.reduce(1, :*)
  end

  def aimless(n)
    n_primes = PrimeSequence.new(n).to_a
    n_primes.push(1) if n_primes.count % 2 == 1

    n_primes.each_slice(2).map {|first, second| Rational(first, second)}.reduce(0, :+)
  end

  def worthless(n)
    target = FibonacciSequence.nth_fibonacci(n)
    number = 0
    number += 1 until RationalSequence.new(number).sum > target

    RationalSequence.new(number - 1).to_a
    end
end