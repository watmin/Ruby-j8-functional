# frozen_string_literal: true

module J8
  class Function
    include J8::Common

    def apply(o)
      @callable.call(o)
    end

    def compose(before = nil, &block)
      callable = from_callable(before, block)

      J8::Function.new(->(o) { apply(callable.apply(o)) })
    end

    def then(after = nil, &block)
      callable = from_callable(after, block)

      J8::Function.new(->(o) { callable.apply(apply(o)) })
    end

    def self.identity
      J8::Function.new { |o| o }
    end
  end
end
