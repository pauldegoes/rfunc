require 'spec_helper'

describe RFunc::Seq do

  let(:seq) { RFunc::Seq.new([1,2,3]) }

  it "throws an exception if anything but an array is provided" do
    expect { RFunc::Seq.new({}) }.to raise_error
  end

  describe "#empty?" do
    context "when there are elements in the Seq" do
      it "returns true" do
        seq.empty?.should == false
      end
    end
    context "when there are no elements in the Seq" do
      it "returns false" do
        RFunc::Seq.new([]).empty?.should == true
      end
    end
  end

  describe "#map" do
    it "allows for simplistic mapping" do
      seq.map {|v| v * 2}.should == RFunc::Seq.new([2, 4, 6])
    end
  end

  describe "#fold" do
    it "allows for simplistic folding from the left" do
      seq.fold({}) {|accum, value| accum["v#{value}"] = value; accum }.to_s.should eq({"v1"=>1, "v2"=>2, "v3"=>3}.to_s)
    end
  end

  describe "#foldl" do
    it "allows for simplistic folding from the left" do
      seq.foldl({}) {|accum, value| accum["v#{value}"] = value; accum }.to_s.should eq({"v1"=>1, "v2"=>2, "v3"=>3}.to_s)
    end
  end

  describe "#foldr" do
    it "allows for simplistic folding from the right" do
      seq.foldr({}) {|accum, value| accum["v#{value}"] = value; accum }.to_s.should eq({"v3"=>3, "v2"=>2, "v1"=>1}.to_s)
    end
  end

  describe "#slice" do
    it "returns a Seq of for the specified range" do
      seq.slice(0,3).should == seq
      RFunc::Seq.new([1,2,3,4,5]).slice(1,3).should == RFunc::Seq.new([2,3,4])
    end
  end

  describe "#head" do
    context "when seq has a head" do
      it "returns the first element of a list" do
        seq.head.should eq(1)
      end
    end
    context "when seq does not have a head" do
      it "throws an exception" do
        expect { RFunc::Seq.new([]).head }.to raise_error
      end
    end
  end

  describe "#first" do
    context "when seq has a head" do
      it "returns the first element of a list" do
        seq.first.should eq(1)
      end
    end
    context "when seq does not have a head" do
      it "throws an exception" do
        expect { RFunc::Seq.new([]).first }.to raise_error
      end
    end
  end

  describe "#head_option" do
    context "when seq has a head" do
      it "returns a Some of the first element of a list" do
        seq.head_option.should == RFunc::Some.new(1)
      end
    end
    context "when seq does not have a head" do
      it "returns a None" do
        RFunc::Seq.new([]).head_option.should == RFunc::None.new
      end
    end
  end

  describe "#first_option" do
    context "when seq has a head" do
      it "returns a Some of the first element of a list" do
        seq.first_option.should == RFunc::Some.new(1)
      end
    end
    context "when seq does not have a head" do
      it "returns a None" do
        RFunc::Seq.new([]).first_option.should == RFunc::None.new
      end
    end
  end

  describe "#tail" do
    context "when seq has only a single item" do
      it "returns an empty seq" do
        RFunc::Seq.new([1]).tail.should == RFunc::Seq.new([])
      end
    end

    context "when seq is empty" do
      it "returns an empty seq" do
        RFunc::Seq.new([1]).tail.should == RFunc::Seq.new([])
      end
    end

    context "when has more than a single member" do
      it "returns an empty seq" do
        seq.tail.should == RFunc::Seq.new([2,3])
      end
    end
  end

  describe "#tail_option" do
    context "when seq has only a single item" do
      it "returns a None" do
        RFunc::Seq.new([1]).tail_option.should == RFunc::None.new
      end
    end

    context "when seq is empty" do
      it "returns a None" do
        RFunc::Seq.new([1]).tail_option.should == RFunc::None.new
      end
    end

    context "when has more than a single member" do
      it "returns a Some of the tail" do
        seq.tail_option.should == RFunc::Some.new(RFunc::Seq.new([2,3]))
      end
    end
  end

  describe "#last" do
    context "when the array has an element" do
      it "returns the final element in the array" do
        seq.last.should == 3
      end
    end
    context "when the array does not have any elements" do
      it "returns nil" do
        RFunc::Seq.new([]).last.should be_nil
      end
    end
  end

  describe "#last_option" do
    context "when the array has an element" do
      it "returns a Some of the final element in the array" do
        seq.last_option.should == RFunc::Some.new(3)
      end
    end
    context "when the array does not have any elements" do
      it "returns a NOne" do
        RFunc::Seq.new([]).last_option.should == RFunc::None.new
      end
    end
  end

  describe "#filter" do
    context "when elements exist that match the provided block" do
      it "returns a seq of matching elements" do
        seq.filter {|el| el < 2}.should == RFunc::Seq.new([1])
      end
    end
    context "when elements exist that do not match the provided block" do
      it "returns an empty Seq" do
        seq.filter {|el| el > 50}.should == RFunc::Seq.new([])
      end
    end
  end

  describe "#find" do
    context "when at least one element exists that matches the provided block" do
      it "returns a Some of the first matching element" do
        seq.find {|el| el < 2}.should == RFunc::Some.new(1)
      end
    end
    context "when at least no elements exist that match the provided block" do
      it "returns a None" do
        seq.find {|el| el > 50}.should == RFunc::None.new
      end
    end
  end

  describe "#reverse" do
    it "returns a reversed sequence" do
      seq.reverse.should == RFunc::Seq.new([3,2,1])
    end
  end

  describe "#[]" do
    context "when specified index is in range" do
      it "returns an element at the specified index" do
        seq[0].should == 1
      end
    end
    context "when specified index is not in range" do
      it "returns nil" do
        seq[10].should == nil
      end
    end
  end

  describe "#members" do
    it "returns the raw ruby Array on which a Seq is built" do
      seq.members.should == [1,2,3]
    end
  end

  describe "#prepend" do
    it "prepends a value to a Seq" do
      seq.prepend(0).should == RFunc::Seq.new([0,1,2,3])
    end
  end

  describe "#append" do
    it "appends a value to a Seq" do
      seq.append(4).should == RFunc::Seq.new([1,2,3,4])
    end
  end

  describe "#collect" do
    it "returns a Seq of members that have been operated on if the block returns a value" do
      seq.collect{|v|
        case v == 2
          when true; v * 4
        end
      }.should == RFunc::Seq.new([8])
    end
  end

  describe "#join" do
    it "joins the elements of the Seq together (into a String) using the supplied character" do
      seq.join(",").should == "1,2,3"
    end
  end

  describe "#collect_first" do
    context "when an element exists for which the supplied block returns true" do
      it "returns a Some of operation" do
        seq.collect_first{|el|
          case el == 2
            when true; el * 100
          end
        }.should == RFunc::Some.new(200)
      end
    end

    context "when an element does not exist for which the supplied block returns true" do
      it "returns a None" do
        seq.collect_first{|el|
          case el == 222
            when true; el * 100
          end
        }.should == RFunc::None.new
      end
    end
  end

  describe "#concat" do
    context "when passing in a Ruby Array" do
      it "returns a Seq with the specified array members concatenated" do
        seq.concat([4,5,6]).should == RFunc::Seq.new([1,2,3,4,5,6])
      end
    end
    context "when passing in a Seq" do
      it "returns a Seq with the specified Seq's members concatenated" do
        seq.concat(RFunc::Seq.new([9,8,7])).should == RFunc::Seq.new([1,2,3,9,8,7])
      end
    end
    context "when an empty array is passed in" do
      it "returns an unchanged Seq" do
        seq.concat([]).should == seq
      end
    end
  end

  describe "#flat_map" do
    context "when the array is empty" do
      it "returns an empty Seq" do
        RFunc::Seq.new().flat_map {|el| [el, el + 1, el + 2] }.should == RFunc::Seq.new
      end
    end
    context "when the array is not empty" do
      it "returns a flattened Seq" do
        seq.flat_map {|el| [el, el + 1, el + 2] }.should == RFunc::Seq.new([1,2,3,2,3,4,3,4,5])
      end
    end
  end

  describe "#flatten" do
    it "returns a flattened Seq" do
      RFunc::Seq.new([[1,2], [3,4]]).flatten.should == RFunc::Seq.new([1,2,3,4])
    end
  end

  describe "#for_all" do
    describe "when none of the elements fail to meet the expectation" do
      it "returns true" do
        seq.for_all {|el| el < 100}.should == true
      end
    end
    describe "when at least one element fails to meet the expectation" do
      it "returns false" do
        seq.for_all {|el| el < 1}.should == false
      end
    end
    describe "when the Seq is empty" do
      it "returns true" do
        RFunc::Seq.new([]).for_all {|el| el < 1}.should == true
      end
    end
  end
end