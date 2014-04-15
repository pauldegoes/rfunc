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

    # Maintains signiture parity with None.get_or_else
    #
    # @param block [Function] the value that would return if the current
    #               Option was a None
    #
    # @return [Any] Option value
    #
    def get_or_else(&block)
      get
    end

    # Maintains signiture parity with None.or_else
    #
    # @param v [Option] the option that would return if the present Option
    #          were a None
    #
    # @return [Option] the current option
    #
    def or_else(v)
      self
    end

    # Operates on the Option value
    #
    # @param block [Function] the function which will be used to operate
    #        on the Option's value
    #
    # @return [Option] the result of the function's operation
    #         as an Option
    #
    def map(&block)
      Option.new(yield(@value))
    end

    # Indicates if the Option has a value
    #
    # @return [Boolean] false
    #
    def empty?
      false
    end

    # Applies a function to the value of the Option and
    # flattens the resulting Option[Option] into a single Option
    #
    # @param block [Function] the function which will operate on the
    #               Option's value (should return an Option)
    #
    # @return [RFunc::Option] the Option result of flattening the current
    #         provided function's option
    #
    def flat_map(&block)
      validated_option_type(yield(get))
    end

    # Operates on the value of the Option
    #
    # @param alternate [Any] the value to return if the Option is a None
    # @param block [Function] the function which will operate on the
    #              current Option's value
    #
    # @return [Any] the result of applying the supplied block to the current
    #               Option value
    #
    def fold(alternate, &block)
      yield(get)
    end

    # Flattens nested Options into a single option
    #
    # @return [Option] a Some if the contained value is a Some or a None
    #         if not
    #
    def flatten
      is_option?(@value) ? @value : self
    end

    # Operates on the value of the Option if it exists and meets a criteria
    #
    # @param block [Function] the block that can be used to modify the value
    #              (should be a case statement with nil return for non operation)
    #
    # @return [Option] the resulting Option containing a value modified by
    #         the supplied block
    #
    def collect(&block)
      result = yield(@value)
      result.nil? ? None.new : Some.new(result)
    end

    # Counts the number of elements for which the block returns true
    #
    # @param block [Function] the function that determines whether the
    #              value should be counted
    #
    # @return [Int] 1 if the block returned true for this Option value or 0 if not
    #
    def count(&block)
      yield(value) == true ? 1 : 0
    end

    # Determines if the current Option value satisfies the supplied block
    #
    # @param block [Function] the function that determines whether the
    #              value satisfies an expectation
    #
    # @return [Boolean] true if the block returns true for the value or false if not
    #
    def for_all(&block)
      yield(@value)
    end

    # Executes the provided block with the current Option value
    #
    # @param block [Function] the function that takes the current Option's value
    #
    # @return [Nil] nil
    #
    def for_each(&block)
      yield(@value)
      nil
    end
  end

  class None < AbstractOption
    def initialize
      super(nil)
    end

    # Allows for the return of a replacement value
    #
    # @param block [Function] a block returning an alternate value
    #
    # @return [Any] the result of the supplied block
    #
    def get_or_else(&block)
      yield
    end

    # Returns an alternative Option for the None
    #
    # @param v [Option] the option to be returned
    #
    # @return [Option] the provided alternate Option
    #
    def or_else(v)
      validated_option_type(v)
    end

    # Maintains signiture parity with Some.map
    #
    # @param block [Function] the function which would be used to operate
    #        on the Option's value
    #
    # @return [None] a None
    #
    def map(&block)
      self
    end

    # Indicates if the Option has a value
    #
    # @return [Boolean] true
    #
    def empty?
      true
    end

    # Maintains signiture parity with Some.flat_map
    #
    # @param block [Function] the function which will operate on the
    #               Option's value (should return an Option)
    #
    # @return [RFunc::Option] a None
    #
    def flat_map(&block)
      self
    end

    # Maintains signiture parity with Some.fold
    #
    # @param alternate [Any] the value to return if the Option is a None
    # @param block [Function] the function which will operate on the
    #              current Option's value
    #
    # @return [Any] the alternate
    #
    def fold(alternate, &block)
      alternate
    end

    # Maintains signiture parity with Some.flatten
    #
    # @return [None] self
    #
    def flatten
      self
    end


    # Maintains signiture parity with Some.collect
    #
    # @param block [Function] the block that can be used to modify the value
    #              (should be a case statement with nil return for non operation)
    #
    # @return [None] self
    #
    def collect(&block)
      self
    end

    # Counts the number of elements for which the block returns true
    #
    # @param block [Function] the function that determines whether the
    #              value should be counted
    #
    # @return [Int] 0 (there is no value to operate on)
    #
    def count(&block)
      0
    end

    # Determines if the current Option value satisfies the supplied block
    #
    # @param block [Function] the function that determines whether the
    #              value satisfies an expectation
    #
    # @return [Boolean] true because the is no value to violate the supplied block
    #
    def for_all(&block)
      true
    end

    # Returns nil (no value to execute on)
    #
    # @param block [Function] the function that takes the current Option's value
    #
    # @return [Nil] nil
    #
    def for_each(&block)
      nil
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