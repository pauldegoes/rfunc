require 'spec_helper'

describe RFunc::Seq do

  let(:seq) { RFunc::Seq.new([1,2,3]) }

  it "throws an exception if anything but an array is provided" do
    expect { RFunc::Seq.new({}) }.to raise_error
  end

  describe "#map" do
    it "allows for simplistic mapping" do
      seq.map {|v| v * 2}.should == RFunc::Seq.new([2, 4, 6])
    end
  end

  describe "#fold" do
    it "allows for simplistic folding" do
      seq.fold({}) {|accum, value| accum["v#{value}"] = value; accum }.should eq({"v1"=>1, "v2"=>2, "v3"=>3})
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
end