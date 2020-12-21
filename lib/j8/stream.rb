# frozen_string_literal: true

module J8
  class Stream
    include J8::Common

    attr_reader :enumerator

    def initialize(enumerator)
      @enumerator = enumerator
    end

    def self.concat(stream1, stream2)
      J8::Stream.new(
        Enumerator.new do |enumerator|
          [stream1, stream2].each do |stream|
            stream.enumerator.each { |o| enumerator << o }
          end
        end
      )
    end

    def self.empty
      [].j8_stream
    end

    def self.generate(supplier = nil, &block)
      supplier = callable_from_proc(supplier, block)

      J8::Stream.new(
        Enumerator.new do |enumerator|
          supplier = J8::Common.from_callable_class(supplier, J8::Supplier)
          loop { enumerator << supplier.get }
        end
      )
    end

    def self.iterate(seed, function = nil, &block)
      supplier = callable_from_proc(supplier, block)

      J8::Stream.new(
        Enumerator.new do |enumerator|
          function = J8::Common.from_callable_class(function, J8::Function)
          loop { enumerator << function.apply(seed) }
        end
      )
    end

    def self.of(*values)
      values.j8_stream
    end

    def all_match?(predicate = nil, &block)
      callable = from_callable_class(predicate, block, J8::Predicate)

      # Handle Ruby's use of #all?
      # [].all? { |n| n == true } => true
      ran = false

      ret = @enumerator.all? do |o|
        ran = true
        callable.test(o) == true
      end

      ran ? ret : false
    end

    def any_match?(predicate = nil, &block)
      callable = from_callable_class(predicate, block, J8::Predicate)

      @enumerator.any? { |o| callable.test(o) }
    end

    def collect
      # figure it out
    end

    def count
      @enumerator.count
    end

    def filter(predicate = nil, &block)
      callable = from_callable_class(predicate, block, J8::Predicate)

      @enumerator.select { |n| predicate.test(n) }.j8_stream
    end

    def find_first
      J8::Optional.new(@enumerator.first)
    end
    alias find_any find_first

    def flat_map(function = nil, &block)
      callable = from_callable_class(function, block, J8::Function)

      @enumerator.map { |n| callable.apply(n) }.flatten.j8_stream
    end

    def each(consumer = nil, &block)
      callable = from_callable_class(consumer, block, J8::Consumer)

      @enumerator.each { |n| callable.accept(n) }
    end

    def limit(size)
      @enumerator.first(size).j8_stream
    end

    def map(function = nil, &block)
      callable = from_callable_class(function, block, J8::Function)

      @enumerator.map { |object| callable.apply(object) }.j8_stream
    end

    def max(comparator = nil, &block)
      callable = from_callable_class(comparator, block, J8::Comparator)

      @enumerator.max { |a, b| callable.compare(a, b) }
    end

    def min(comparator = nil, &block)
      callable = from_callable_class(comparator, block, J8::Comparator)

      @enumerator.min { |a, b| callable.compare(a, b) }
    end

    def none_match?(predicate = nil, &block)
      callable = from_callable_class(predicate, block, J8::Predicate)

      # Handle Ruby's use of #all?
      # [].all? { |n| n == true } => true
      ran = false

      ret = @enumerator.all? do |object|
        ran = true
        callable.test(object) != true
      end

      ran ? ret : false
    end

    def peek(consumer = nil, &block)
      callable = from_callable_class(consumer, block, J8::Consumer)

      @enumerator.entries.tap do |entries|
        entries.each { |v| callable.accept(v) }
        @enumerator.rewind
      end.j8_stream
    end

    def reduce(binary_operator = nil, memo: nil, &block)
      callable = from_callable_class(binary_operator, block, J8::BinaryOperator)

      J8::Optional.of(
        @enumerator.reduce(memo) do |accumulator, object|
          callable.apply(accumulator, object)
        end
      )
    end

    def skip(amount)
      @enumerator.slice_after(amount).to_a.last.j8_stream
    end

    def sort
      @enumerator.sort.j8_stream
    end

    def sort_by(comparator = nil, &block)
      callable = from_callable_class(comparator, block, J8::Comparator)

      @enumerator.sort { |a, b| callable.compare(a, b) }.j8_stream
    end

    def to_a
      @enumerator.to_a
    end
  end
end
