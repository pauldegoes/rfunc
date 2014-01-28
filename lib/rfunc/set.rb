module RFunc
  class Set
    def initialize(set=[])
      raise "RFunc::Set must be initialized with an Array.  #{set.class} is not an Array" if set.class != Array

      @set = set
    end

    def head
      raise "RFunc::Set #{set} has no head" if @set.size == 0
      @set[0]
    end

    def tail
      @set[1..-1] || []
    end

    def map(&block)
      @set.map{|v| yield(v) }
    end

    def fold(accum, &block)
      @set.inject(accum) {|a, el| yield(a, el) }
    end

    def filter(&block)

    end

    private
  end
end