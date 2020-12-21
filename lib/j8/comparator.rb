# frozen_string_literal: true

module J8
  class Comparator
    include J8::Common

    def self.comparing(extractor, comparator)
      extractor = from_callable_class(extractor, nil, J8::Function)
      comparator = from_callable_class(comparator, nil, J8::Comparator)

      J8::Comparataor.new(
        lambda do |o1, o2|
          comparator.compare(extractor.apply(o1), extractor.apply(o2))
        end
      )
    end

    def compare(o1, o2)
      raise J8::NilException if o1.nil?
      raise J8::NilException if o2.nil?

      @callable.call(o1, o2)
    end
  end
end
