# frozen_string_literal: true

module J8
  class BiPredicate
    include J8::Common

    def test(o1, o2)
      @callable.call(o1, o2)
    end

    def negate
      J8::BiPredicate.new(->(o1, o2) { !test(o1, o2) })
    end

    def and(other = nil, &block)
      callable = from_callable(other, block)

      J8::BiPredicate.new(->(o1, o2) { test(o1, o2) && callable.test(o1, o2) })
    end

    def or(other = nil, &block)
      callable = from_callable(other, block)

      J8::BiPredicate.new(->(o1, o2) { test(o1, o2) || callable.test(o1, o2) })
    end
  end
end
