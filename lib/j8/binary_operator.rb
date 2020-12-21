# frozen_string_literal: true

module J8
  class BinaryOperator < J8::BiFunction
    def self.max_by(comparator = nil, &block)
      callable = from_callable_class(comparator, block, J8::Comparator)

      J8::BinaryOperator.new(->(a, b) { callable.compare(a, b) <= 0 ? a : b })
    end

    def self.min_by(comparator = nil, &block)
      callable = from_callable_class(comparator, block, J8::Comparator)

      J8::BinaryOperator.new(->(a, b) { callable.compare(a, b) >= 0 ? a : b })
    end
  end
end
