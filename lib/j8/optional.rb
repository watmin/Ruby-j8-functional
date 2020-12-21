# frozen_string_literal: true

module J8
  class Optional
    include J8::Common

    def initialize(value = nil)
      @value = value
    end

    def self.empty
      J8::Optional.new
    end

    def self.of(value)
      raise J8::NilException if value.nil?

      J8::Optional.new(value)
    end

    def self.of_nilable(value)
      J8::Optional.new(value)
    end

    def empty?
      @value.nil?
    end

    def equals?(object)
      @value == object
    end
    alias == equals?

    def filter(predicate = nil, &block)
      callable = from_callable_class(predicate, block, J8::Predicate)

      if present? && callable.test(@value)
        J8::Optional.new(@value)
      else
        J8::Optional.empty
      end
    end

    def flat_map(function = nil, &block)
      callable = from_callable_class(function, block, J8::Function)
      return J8::Optional.empty unless present?

      callable.apply(@value).tap do |result|
        raise J8::NilException if result.nil?
      end
    end

    def get
      raise J8::NoSuchElementException unless present?

      @value
    end
    alias value get

    def if_present(consumer = nil, &block)
      callable = from_callable_class(consumer, block, J8::Consumer)
      return unless present?

      callable.accept(@value)
    end

    def present?
      !@value.nil?
    end

    def map(function = nil, &block)
      callable = from_callable_class(function, block, J8::Function)
      return J8::Optional.empty unless present?

      J8::Optional.new(callable.apply(@value))
    end

    def or_else(value)
      if present?
        @value
      else
        value
      end
    end

    def or_else_get(supplier = nil, &block)
      callable = from_callable_class(supplier, block, J8::Supplier)

      if present?
        @value
      else
        callable.get.tap do |result|
          raise J8::NilException if result.nil?
        end
      end
    end

    def or_else_raise(supplier = nil, &block)
      callable = from_callable_class(supplier, block, J8::Supplier)

      if present?
        @value
      else
        raise callable.get
      end
    end
  end
end
