require 'spec_helper'

describe RFunc do
  include RFunc
  describe "#Seq" do
    it "returns an RFunc::Seq" do
      Seq([1,2,3]).class.should == RFunc::Seq
    end
  end

  describe "#Option" do
    it "returns the appropriate RFunc::Option" do
      Option(nil).class.should == RFunc::None
      Option("foo").class.should == RFunc::Some
    end
  end

  describe "#Some" do
    it "returns the an RFunc::Some" do
      Some(1).class.should == RFunc::Some
    end
  end

  describe "#None" do
    it "returns the an RFunc::None" do
      None().class.should == RFunc::None
    end
  end
end