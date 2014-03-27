require 'rfunc/errors'

module RFunc
  class AbstractOption
    def initialize(value)
      @value = value
    end

    def ==(object)
      object.class == self.class && object.get == @value
    end

    def get; @value end

    def get_or_else(&block)
      empty? ? yield : get
    end

    def or_else(v)
      empty? ? validated_option_type(v) : self
    end

    # returns an Option
    def map(&block)
      case self
        when RFunc::Some
          Option.new(yield(@value))
        else
          self
      end
    end

    def empty?
      @empty ||= case self
        when RFunc::Some
          false
        else
          true
      end
    end

    def flat_map(&block)
      if empty?
        None.new
      else
        validated_option_type(yield(get))
      end
    end

    private

      def validated_option_type(r)
        raise RFunc::Errors::InvalidReturnType.new(r, AbstractOption) if !r.is_a?(AbstractOption)
        r
      end
  end

  class Some < AbstractOption
    def initialize(something)
      throw "RFunc::Some cannot be initialized with a nil" if something.nil?
      super(something)
    end
  end

  class None < AbstractOption
    def initialize
      super(nil)
    end
  end

  module Option
    def self.new(something_or_nothing)
      case something_or_nothing.nil?
        when false
          Some.new(something_or_nothing)
        else
          None.new
      end
    end
  end
end