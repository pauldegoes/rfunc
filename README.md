# RFunc

This gem provides access to a functionally oriented collections library.  First release will include Seq and Option support.

## Installation

Add this line to your application's Gemfile:

    gem 'rfunc'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rfunc

## Usage

###RFunc
The RFunc module provides access to some helper methods that let you form RFunc classes in a less verbosity.

      `require "rfunc"

      include RFunc

      seq([1,2,3]) => RFunc::Seq(1,2,3)

      option(nil)  => RFunc::None

      option(1)  => RFunc::Some(1)
      `

####RFunc::Seq
The RFunc::Seq (Sequence) is a replacement for the Ruby Array class which it accepts and provides the following methods:

* [] => access an element of the Seq by index
* head => return the first element of the Seq
* head_option => return an Option of the first element of the Seq
* tail => return all elements of the Seq except the head
* tail_option => return an Option of all the elements of the Seq
* map(block) => returns a Seq, the members of which have been operated on by the provided block

## Contributing

1. Fork it ( http://github.com/<my-github-username>/rfunc/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
