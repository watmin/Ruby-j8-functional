# frozen_string_literal: true

require 'j8/functional/version'
require 'j8/functional/exceptions'
require 'j8/common'

require 'j8/bi_consumer'
require 'j8/bi_function'
require 'j8/predicate'
require 'j8/collector'
require 'j8/supplier'
require 'j8/optional'
require 'j8/function'
require 'j8/consumer'
require 'j8/comparator'
require 'j8/stream'

class Object
  def j8_stream
    if self.class.ancestors.include?(Enumerable)
      J8::Stream.new(each)
    else
      J8::Stream.new([self].each)
    end
  end
end
