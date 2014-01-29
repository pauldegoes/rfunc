require 'spec_helper'

describe RFunc::Seq do

  let(:set) { RFunc::Seq.new([1,2,3]) }

  it "throws an exception if anything but an array is provided" do
    expect { RFunc::Seq.new({}) }.to raise_error
  end

  describe "#map" do
    it "allows for simplistic mapping" do
      set.map {|v| v * 2}.should eq([2, 4, 6])
    end
  end

  describe "#fold" do
    it "allows for simplistic folding" do
      set.fold({}) {|accum, value| accum["v#{value}"] = value; accum }.should eq({"v1"=>1, "v2"=>2, "v3"=>3})
    end
  end

  describe "#head" do
    context "when set has a head" do
      it "returns the first element of a list" do
        set.head.should eq(1)
      end
    end
    context "when set does not have a head" do
      it "throws an exception" do
        expect { RFunc::Seq.new([]).head }.to raise_error
      end
    end
  end

  describe "#tail" do
    context "when set has only a single item" do
      it "returns an empty set" do
        RFunc::Seq.new([1]).tail.should eq([])
      end
    end

    context "when set is empty" do
      it "returns an empty set" do
        RFunc::Seq.new([1]).tail.should eq([])
      end
    end

    context "when has more than a single member" do
      it "returns an empty set" do
        set.tail.should eq([2,3])
      end
    end
  end

  describe "#filter" do
    context "when elements exist that match the provided block" do
      it "returns a set of matching elements" do
        set.filter {|el| el < 2}.should == RFunc::Seq.new([1])
      end
    end
    context "when elements exist that do not match the provided block" do
      it "returns an empty Seq" do
        set.filter {|el| el > 50}.should == RFunc::Seq.new([])
      end
    end
  end

  describe "#find" do
    context "when at least one element exists that matches the provided block" do
      it "returns a Some of the first matching element" do
        set.find {|el| el < 2}.should == RFunc::Some.new(1)
      end
    end
    context "when at least no elements exist that match the provided block" do
      it "returns a None" do
        set.find {|el| el > 50}.should == RFunc::None.new
      end
    end
  end
end