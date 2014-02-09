require "rfunc/option"

module RFunc
  class Seq
    def initialize(set=[])
      raise "RFunc::Seq must be initialized with an Array.  #{set.class} is not an Array" if set.class != Array

      @set = set
    end

    def all
      @all ||= Seq.new(@set)
    end

    def <<(el)
      Seq.new(@set << el)
    end

    def +(seq2)
      Seq.new(@set + seq2)
    end

    def ==(object)
      object.class == self.class && object.members == @set
    end

    def members
      @set
    end

    def [](v)
      @set[v]
    end

    def head
      raise "RFunc::Seq #{@set} has no head" if @set.size == 0
      @head ||= raw_head
    end

    def head_option
      @head_option ||= (h_e = raw_head) ? Some.new(h_e) : None.new
    end

    def tail_option
      (tail[0]) ? Some.new(tail) : None.new
    end

    def tail
      @tail ||= (t_s = @set[1..-1]) ? Seq.new(t_s) : Seq.new
    end

    def map(&block)
      Seq.new(@set.map{|v| yield(v) })
    end

    def fold(accum, &block)
      head_option.map{|h|
        tail_option.map{|t|
          t.fold(block.call(accum, h)) {|a, el|
            yield(a, el)
          }
        }.get_or_else{ yield(accum, h) }
      }.get_or_else{ accum }
    end

    def foldr(accum, &block)
      Seq.new(@set.reverse).fold(accum) {|accum, el| yield(accum, el) }
    end

    alias_method :foldl, :fold

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

    def collect(&block)
      fold(Seq.new([])) {|accum, el| (res = yield(el)) ? accum.append(res) : accum }
    end

    private
      def raw_head; @set[0] end
  end
end