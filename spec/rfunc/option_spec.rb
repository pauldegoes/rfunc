require 'spec_helper'

describe RFunc::Option do
  describe "#new" do
    it "returns a Some when a value is supplied" do
      RFunc::Option.new(1).should == RFunc::Some.new(1)
    end

    it "returns a None when a value is not supplied" do
      RFunc::Option.new(nil).should == RFunc::None.new
    end
  end

  describe "#map" do
    context "when Option is Some" do
      let(:option) { RFunc::Option.new(1) }
      it "extracts the value from an Option and returns an Option" do
        option.map {|v| v.should == 1; 2 }.should == RFunc::Some.new(2)
      end
    end
    context "when Option is None" do
      let(:option) { RFunc::Option.new(nil) }
      it "doesn't extract the value and returns a None" do
        option.map {|v| throw "this should not be executed" }.should == RFunc::None.new
      end
    end
  end

  describe "#empty?" do
    context "for an Option initialized with nil" do
      it "returns true" do
        RFunc::Option.new(nil).empty?.should be_true
      end
    end

    context "for an None" do
      it "returns true" do
        RFunc::None.new.empty?.should be_true
      end
    end

    context "for an Some" do
      it "returns false" do
        RFunc::Some.new(1).empty?.should be_false
      end
    end

    context "for an Option initialized with a value" do
      it "returns false" do
        RFunc::Option.new(1).empty?.should be_false
      end
    end
  end
end