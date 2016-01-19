def prime?(number)
  divisors = 0

  2.upto(number-1).each {|x| divisors += 1 if number % x == 0  }

  case number
    when 0 then false
    when 1 then false
    else number == 2 or divisors == 0
  end
end
def prime?(number)
  divisors = 0

  2.upto(number-1).each {|x| divisors += 1 if number % x == 0  }

  case number
    when 0 then false
    when 1 then false
    else number == 2 or divisors == 0
  end
end

def increasing_numerator(numerator, denominator)
    numerator += 1
    denominator -= 1 unless denominator == 1

    return numerator, denominator if numerator.gcd(denominator) == 1
    return increasing_numerator(numerator, denominator) if numerator.gcd(denominator) > 1
 end

def decreasing_numerator(numerator, denominator)
  numerator -= 1 unless numerator == 1
  denominator += 1

  return numerator, denominator if numerator.gcd(denominator) == 1
  return decreasing_numerator(numerator, denominator) if numerator.gcd(denominator) > 1
end

def rational_generator(n)
  return  Rational(1,1) if n ==  1

  denominator = rational_generator(n-1).denominator
  numerator = rational_generator(n-1).numerator

  if (numerator + denominator) % 2 == 0
    numerator_incremented = increasing_numerator(numerator, denominator)[0]
    denominator_incremented = increasing_numerator(numerator, denominator)[1]
  else
    numerator_incremented = decreasing_numerator(numerator, denominator)[0]
    denominator_incremented = decreasing_numerator(numerator, denominator)[1]
  end

  Rational(numerator_incremented, denominator_incremented)
end

def nth_fibonacci(place, first: 1, second: 1)
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


class PrimeSequence
  include Enumerable

  def initialize(number)
    infinity = 1.0/0
    @sequence = (1..infinity).lazy.select{|n| prime?(n)}.take(number)
  end

  def each(&block)
    @sequence.each(&block)
   end
end


class FibonacciSequence
  include Enumerable

  def initialize(number, first: 1, second: 1)
    @sequence = 1.upto(number).map {|n| nth_fibonacci(n, first: first, second: second )}
  end

  def each(&block)
    @sequence.each(&block)
  end

end


class RationalSequence
  include Enumerable

  def initialize(number)
    @sequence = 1.upto(number).map {|n| rational_generator(n)}
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
    group_1 = n_rationals.select {|x| prime?(x.numerator) or prime?(x.denominator)}
    group_2 = n_rationals.select {|x| not (prime?(x.numerator) or prime?(x.denominator))}

    group_1.reduce(1, :*) / group_2.reduce(1, :*)
  end

  def aimless(n)
    n_primes = PrimeSequence.new(n).to_a
    n_primes.push(1) if n_primes.count % 2 == 1

    n_primes.each_slice(2).map {|first, second| Rational(first, second)}.reduce(0, :+)
  end

  def worthless(n)
    number = 0
    number +=1 until RationalSequence.new(number).sum > nth_fibonacci(n)

    RationalSequence.new(number-1).to_a
    end
end