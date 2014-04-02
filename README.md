# RFunc

This gem provides access to a functionally oriented collections library.  First release will include Seq and Option support.

## Installation

Add this line to your application's Gemfile:

    gem 'rfunc'

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install rfunc

## Usage

###RFunc
The RFunc module provides access to some helper methods that let you form RFunc classes in a less verbosity.

      require "rfunc"

      include RFunc

      Seq([1,2,3]) => RFunc::Seq(1,2,3)

      Option(nil)  => RFunc::None

      Option(1)  => RFunc::Some(1)


####RFunc::Seq
The RFunc::Seq (Sequence) is a replacement for the Ruby Array class which it accepts and provides the following methods:

* [] => access an element of the Seq by index

        RFunc::Seq.new([1])[0] => 1

* head => return the first element of the Seq

        RFunc::Seq.new([1]).head => 1

* head_option => return an Option of the first element of the Seq

        RFunc::Seq.new([1]).head_option => Some(1)

* tail => return all elements of the Seq except the head

        RFunc::Seq.new([1,2,3]).tail => Seq([2,3])

* tail_option => return an Option of all the elements of the Seq

        RFunc::Seq.new([1,2,3]).tail_option => Some(Seq([2,3]))

* map(block) => returns a Seq, the members of which have been operated on by the provided block

        RFunc::Seq.new([1,2,3]).map{|v| v*2 } => Seq([2, 4, 6])

* slice(from, to) => returns a Seq containing the given range

        RFunc::Seq.new([1,2,3,4,5]).slice(2,3) => Seq([2,3,4])

* fold(accum, &block) => returns the value of the yielded block, which takes an accumulator and a Seq element from left to right

        RFunc::Seq.new([1,2,3]).fold(RFunc::Seq.new([])) {|accum, el| accum.append(el + el) } => Seq([2,4,6])

* foldr(accum, &block) => returns the value of the yielded block, which takes an accumulator and a Seq element from right to left

        RFunc::Seq.new([1,2,3]).foldr(RFunc::Seq.new([])) {|accum, el| accum.append(el + el) } => Seq([6,4,2])

* first_option => returns an Option of the first element (Some of None)

        RFunc::Seq.new([1,2]).first_option => Some(1)
        RFunc::Seq.new([]).first_option => None

* last_option => returns an Option of the last element (Some of None)

        RFunc::Seq.new([1,2]).last_option => Some(2)
        RFunc::Seq.new([]).last_option => None

* append(el) => returns an RFunc::Seq with the element appended

        RFunc::Seq.new([1]).append(2) => Seq([1,2])

* prepend(el) => returns an RFunc::Seq with the element prepended

        RFunc::Seq.new([2]).prepend(1) => Seq([1,2])

* empty? => returns true or false based on whether or not there are elements in the Seq

        RFunc::Seq.new([]).empty? => true
        RFunc::Seq.new([1]).empty? => false

* reverse => returns an RFunc::Seq with the elements reversed

        RFunc::Seq.new([1,2,3,4,5]).reverse => Seq([5,4,3,2,1])

* concat => returns an RFunc::Seq with the provided elements appended
        RFunc::Seq.new([1,2,3]).concat([2,1]) => Seq([1, 2, 3, 2, 1])
        RFunc::Seq.new([1,2,3]).concat(RFunc::Seq.new([2,1])) => Seq([1, 2, 3, 2, 1])

* flat_map => returns a flattened RFunc::Seq, whose members are derived from operating on each element of the existing Seq
        RFunc::Seq.new([1,2,3]).flat_map {|el| [el, el -1, el -2] } => Seq([1, 0, -1, 2, 1, 0, 3, 2, 1]>)

## CAVEATES

Ruby is NOT a functional language, nor is it optimized for functional code (tail call recursion for instance).  As a result, this library utilizes native Ruby comprehensions in order to remain performant and useful.  Any libraries built on this code should take the same approach.

## TODO

* Complete Seq library
* Complete Option library
  * for_all
  * for_each
  * head

## Contributing

1. Fork it ( http://github.com/<my-github-username>/rfunc/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
