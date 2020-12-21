# frozen_string_literal: true

module J8
  class Consumer
    include J8::Common

    def accept(o)
      @callable.call(o)
    end

    def then(after = nil, &block)
      callable = from_callable(after, block)

      J8::Consumer.new(
        lambda do |o|
          accept(o)
          callable.accept(o)
        end
      )
    end
  end
end
