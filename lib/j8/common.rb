# frozen_string_literal: true

module J8
  module Common
    module_function

    def initialize(callable = nil, &block)
      @callable = callable_from_proc(callable, block)
    end

    def lambda?(o)
      o.is_a?(Proc) && o.lambda?
    end

    def raise_unless_lambda(o)
      return if lambda?(o)

      raise ArgumentError, "(#{o.class}) '#{o}' is not a lambda"
    end

    def from_callable(callable, block)
      callable = callable_from_proc(callable, block)

      if callable.is_a?(self.class)
        callable
      else
        raise_unless_lambda(callable)

        self.class.new(callable)
      end
    end

    def from_callable_class(callable, block, klass)
      if callable.is_a?(klass)
        callable
      else
        callable = callable_from_proc(callable, block)
        raise_unless_lambda(callable)

        klass.new(callable)
      end
    end

    def make_lambda(block)
      Object.new.tap { |n| n.define_singleton_method(:_, block) }.method(:_).to_proc
    end

    def callable_from_proc(callable, block)
      if block.nil?
        raise J8::NilException if callable.nil?
        raise_unless_lambda(callable)

        callable
      else
        make_lambda(block)
      end
    end
  end
end
