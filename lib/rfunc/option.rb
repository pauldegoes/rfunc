module RFunc
  class AbstractOption
    def initialize(value)
      @value = value
    end

    def ==(object)
      object.class == self.class && object.get == @value
    end

    def get; @value end

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
      case self
        when RFunc::Some
          false
        else
          true
      end
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