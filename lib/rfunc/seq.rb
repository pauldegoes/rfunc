require "rfunc/option"

module RFunc
  class Seq
    def initialize(seq=[])
      raise "RFunc::Seq must be initialized with an Array.  #{seq.class} is not an Array" if seq.class != Array

      @array = seq
    end

    def all
      Seq.new(@array)
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
     raw_head
    end

    alias_method :first, :head

    def head_option
      (h_e = raw_head) ? Some.new(h_e) : None.new
    end

    alias_method :first_option, :head_option

    def tail_option
      (tail[0]) ? Some.new(tail) : None.new
    end

    def tail
      @tail ||= (t_s = @array[1..-1]) ? Seq.new(t_s) : Seq.new
    end

    def last
      @array.at(@array.size - 1)
    end

    def last_option
      l = last
      l ? Some.new(l) : None.new
    end

    def map(&block)
      Seq.new(@array.map{|v| yield(v) })
    end

    def fold(accum, &block)
      @array.inject(accum) {|a, el| yield(a, el) }
    end

    def foldr(accum, &block)
      @array.reverse.inject(accum) {|a, el| yield(a, el) }
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
          accum.append(el)
        else
          accum
        end
      }
    end

    def find(&block)
      RFunc::Option.new(@array.find {|el| yield(el) })
    end

    def collect(&block)
      fold(Seq.new([])) {|accum, el| (res = yield(el)) ? accum.append(res) : accum }
    end

    def collect_first(&block)
      # more performant than it's prettier version
      result = nil
      find {|el| result = yield(el) }
      result ? RFunc::Some.new(result) : RFunc::None.new
    end

    def join(char)
      @array.join(char)
    end

    def concat(seq_or_array)
      if seq_or_array.is_a?(Seq)
        Seq.new(@array.concat(seq_or_array.members))
      else
        Seq.new(@array.concat(seq_or_array))
      end
    end

    def flat_map(&block)
      fold(Seq.new) {|accum, el|
        accum.concat(yield(el))
      }
    end

    def flatten
      Seq.new(@array.flatten)
    end

    def count; @array.size end

    def for_all(&block)
      @array.all?{|el| yield(el) }
    end

    def for_each(&block)
      @array.each {|el| yield(el) }
    end

    private
      def raw_head; @array[0] end
  end
end