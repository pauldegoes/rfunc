require 'rfunc/errors'

module RFunc
  class AbstractOption
    # Initializes the class
    #
    # @param value [Any] the initial value of the Option
    #
    # @return [AbstractOption] and instance of the class
    #
    def initialize(value)
      @value = value
    end


    # Comparator that allows one Option to be compared against another
    # by value
    #
    # @return [Boolean] true if the Option values are identical and false
    #         if not
    #
    def ==(object)
      object.class == self.class && object.get == @value
    end

    # Extracts the value of the option
    #
    # @return [Any] the value of the option
    def get; @value end


    # Extracts the value of the Option if it is a Some or returns a
    # replacement
    #
    # @param block [Function] the value to return if the current
    #               Option is a None
    #
    # @return [Any] Either the Option value (if the current Option is
    #         a Some) or result of the supplied block
    #
    def get_or_else(&block)
      empty? ? yield : get
    end


    # Supplies a replacement Option if the present Option is a None
    #
    # @param v [Option] the option to return if the present Option
    #          is a None
    #
    # @return [Option] the current option if it is a Some or the supplied
    #         Option if it is a None
    #
    def or_else(v)
      empty? ? validated_option_type(v) : self
    end

    # Operates on the Option value if present
    #
    # @param block [Function] the function which will be used to operate
    #        on the Option's value if present
    #
    # @return [Option] the result of the function's operation
    #         as an Option
    #
    def map(&block)
      case self
        when RFunc::Some
          Option.new(yield(@value))
        else
          self
      end
    end

    # Indicates if the Option has a value
    #
    # @return [Boolean] the boolean value indicating whether
    #          or not the Option has a value (is a Some)
    #
    def empty?
      @empty ||= case self
        when RFunc::Some
          false
        else
          true
      end
    end

    # Applies a function to the value of the Option if present and
    # flattens the resulting Option[Option] into a single Option
    #
    # @param block [Function] the function which will operate on the
    #               Option's value if present (should return an Option)
    #
    # @return [RFunc::Option] the Option result of flattening the current
    #         provided function's option
    #
    def flat_map(&block)
      if empty?
        None.new
      else
        validated_option_type(yield(get))
      end
    end

    # Filters the Some by a given function
    #
    # @param block [Function] the function which will operate on the
    #               option's value if present (should return Bool) and
    #               be used to determine if a Some of None will be
    #               returned
    # @return [RFunc::Option] the Option result of the filter
    #
    def filter(&block)
      map {|el| yield(el)}.get_or_else { false } ? self : None.new
    end

    # Filters the Some by the inverse of a given function
    #
    # @param block [Function] the function which will operate on the
    #               option's value if present (should return Bool) and
    #               be used to determine if a Some of None will be
    #               returned
    # @return [RFunc::Option] the Option result of the filter
    #
    def filter_not(&block)
      map {|el| !yield(el) }.get_or_else { false } ? self : None.new
    end

    alias_method :find, :filter

    # Operates on the value of the Option if it is a Some or provides
    # an alternate if it is a None
    #
    # @param alternate [Any] the value to return if the Option is a None
    # @param block [Function] the function which will operate on the
    #              current Option's value if it is a Some
    #
    # @return [Any] the alternate value (if the current Option is a None)
    #               of the value of the provided block
    #
    def fold(alternate, &block)
      if empty?
        alternate
      else
        yield(get)
      end
    end

    # Flattens nested Options into a single option
    #
    # @return [Option] a Some if the contained value is a Some or a None
    #         if not
    #
    def flatten
      throw "#{__method__} must be defined in the subclass"
    end

    # Operates on the value of the Option if it exists and meets a criteria
    #
    # @param block [Function] the block that can be used to modify the value
    #              (should be a case statement with nil return for non operation)
    #
    # @return [Option] the resulting Option containing a modified value if the
    #         current Option is a Some or a None if not
    #
    def collect(&block)
      throw "#{__method__} must be defined in the subclass"
    end

    # Counts the number of elements for which the block returns true
    #
    # @param block [Function] the function that determines whether the
    #              value should be counted
    #
    # @return [Int] 1 if the block returned true for this Option value or 0 if not
    def count(&block)
      throw "#{__method__} must be defined in the subclass"
    end

    # Tests whether or not an object is an Option
    #
    # @param el [Any] the object to test
    #
    # @return [Boolean] true if the object is an Option or false if not
    #
    def is_option?(el)
      el.is_a?(AbstractOption)
    end

    private

      def validated_option_type(r)
        raise RFunc::Errors::InvalidReturnType.new(r, AbstractOption) if !is_option?(r)
        r
      end
  end

  class Some < AbstractOption
    def initialize(something)
      throw "RFunc::Some cannot be initialized with a nil" if something.nil?
      super(something)
    end

    def flatten
      is_option?(@value) ? @value : self
    end

    def collect(&block)
      result = yield(@value)
      result.nil? ? None.new : Some.new(result)
    end

    def count(&block)
      yield(value) == true ? 1 : 0
    end
  end

  class None < AbstractOption
    def initialize
      super(nil)
    end

    def flatten
      self
    end

    def collect(&block)
      self
    end

    def count(&block)
      0
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