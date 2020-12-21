# frozen_string_literal: true

module J8
  class Predicate
    include J8::Common

    def self.equal?(target)
      J8::Predicate.new(->(o) { o == target })
    end

    def test(o)
      @callable.call(o)
    end

    def negate
      J8::Predicate.new(->(o) { !test(o) })
    end

    def and(other = nil, &block)
      callable = from_callable(other, block)

      J8::Predicate.new(->(o) { test(o) && callable.test(o) })
    end

    def or(other = nil, &block)
      callable = from_callable(other, block)

      J8::Predicate.new(->(o) { test(o) || callable.test(o) })
    end
  end
end
