require 'spec_helper'

describe RFunc do
  include RFunc
  describe "#seq" do
    it "returns an RFunc::Seq" do
      seq([1,2,3]).class.should == RFunc::Seq
    end
  end

  describe "#option" do
    it "returns the appropriate RFunc::Option" do
      option(nil).class.should == RFunc::None
      option("foo").class.should == RFunc::Some
    end
  end

  describe "#some" do
    it "returns the an RFunc::Some" do
      some(1).should.class == RFunc::Some
    end
  end

  describe "#none" do
    it "returns the an RFunc::None" do
      none.should.class == RFunc::None
    end
  end
end