# frozen_string_literal: true

module J8
  class Supplier
    include J8::Common

    def get
      @callable.call
    end
  end
end
