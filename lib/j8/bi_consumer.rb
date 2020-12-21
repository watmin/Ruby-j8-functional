# frozen_string_literal: true

module J8
  class BiConsumer
    include J8::Common

    def accept(o1, o2)
      @callable.call(o1, o2)
    end

    def then(after = nil, &block)
      callable = from_callable(after, block)

      J8::BiConsumer.new(
        lambda do |o1, o2|
          accept(o1, o2)
          callable.accept(o1, o2)
        end
      )
    end
  end
end
