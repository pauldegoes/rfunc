require "rfunc/option"

module RFunc
  class Seq
    def initialize(set=[])
      raise "RFunc::Seq must be initialized with an Array.  #{set.class} is not an Array" if set.class != Array

      @array = set
    end

    def all
      @all ||= Seq.new(@array)
    end

    def <<(el)
      Seq.new(@array << el)
    end

    def +(seq2)
      Seq.new(@array + seq2)
    end

    def ==(object)
      object.class == self.class && object.members == @array
    end

    def members
      @array
    end

    def [](v)
      @array[v]
    end

    def empty?
      @array.size == 0
    end

    def head
      raise "RFunc::Seq #{@array} has no head" if @array.size == 0
      @head ||= raw_head
    end

    alias_method :first, :head

    def head_option
      @head_option ||= (h_e = raw_head) ? Some.new(h_e) : None.new
    end

    alias_method :first_option, :head_option

    def tail_option
      (tail[0]) ? Some.new(tail) : None.new
    end

    def tail
      @tail ||= (t_s = @array[1..-1]) ? Seq.new(t_s) : Seq.new
    end

    def last
      @last ||= @array.at(@array.size - 1)
    end

    def last_option
      @last_option ||= last ? Some.new(last) : None.new
    end

    def map(&block)
      Seq.new(@array.map{|v| yield(v) })
    end

    def fold(accum, &block)
      head_option.map{|h|
        tail_option.map{|t|
          t.fold(yield(accum, h)) {|a, el|
            yield(a, el)
          }
        }.get_or_else{ yield(accum, h) }
      }.get_or_else{ accum }
    end

    def foldr(accum, &block)
      last_option.map{|t|
        sliced = slice(0, @array.size - 1)

        if (!sliced.empty?)
          sliced.foldr(yield(accum, t)) {|a, el|
            yield(a, el)
          }
        else
          yield(accum, t)
        end
      }.get_or_else{ accum }
    end

    alias_method :foldl, :fold

    def slice(from, to)
      Seq.new(@array.slice(from, to))
    end

    def prepend(el)
      Seq.new(@array.unshift(el))
    end

    def append(el)
      Seq.new(@array.push(el))
    end

    def reverse
      Seq.new(@array.reverse)
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
      def raw_head; @array[0] end
  end
end