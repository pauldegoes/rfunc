require "rfunc/option"

module RFunc
  class Seq
    def initialize(set=[])
      raise "RFunc::Seq must be initialized with an Array.  #{set.class} is not an Array" if set.class != Array

      @set = set
    end

    def ==(object)
      object.class == self.class && object.members == @set
    end

    def members
      @set
    end

    def head
      raise "RFunc::Seq #{@set} has no head" if @set.size == 0
      raw_head
    end

    def head_option
      (h_e = raw_head) ? Some.new(h_e) : None.new
    end

    def tail
      @set[1..-1] || Seq.new
    end

    def map(&block)
      @set.map{|v| yield(v) }
    end

    def fold(accum, &block)
      @set.inject(accum) {|a, el| yield(a, el) }
    end

    def prepend(el)
      Seq.new(@set.unshift(el))
    end

    def append(el)
      Seq.new(@set.push(el))
    end

    def reverse
      Seq.new(@set.reverse)
    end

    def filter(&block)
      fold(Seq.new) {|accum, el|
        if yield(el)
          accum.prepend(el)
        else
          accum
        end
      }.reverse
    end

    def find(&block)
      filter {|el| yield(el) }.head_option
    end

    private
      def raw_head; @set[0] end
  end
end