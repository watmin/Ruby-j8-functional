# frozen_string_literal: true

module J8
  class BiFunction
    include J8::Common

    def apply(o1, o2)
      @callable.call(o1, o2)
    end

    def then(after = nil, &block)
      callable = from_callable(after, block)

      J8::BiFunction.new(->(o1, o2) { callable.apply(*apply(o1, o2)) })
    end
  end
end
