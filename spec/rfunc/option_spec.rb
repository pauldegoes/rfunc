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

  describe "#flat_map" do
    context "when the option is a None" do
      it "does not perform the operation" do
        expect {
          RFunc::None.new.flat_map{|v| throw 'should not throw anything' }
        }.not_to raise_error
      end
    end
    context "when the option is a Some and return type is not a Some of None" do
      it "raises an error" do
        expect {
          RFunc::Some.new(1).flat_map{|v| v + v }
        }.to raise_error(RFunc::Errors::InvalidReturnType)
      end
    end
    context "when the option is a Some" do
      it "returns the result of the yield" do
        RFunc::Some.new(1).flat_map{|v| RFunc::Some.new(v + v) }.should == RFunc::Some.new(2)

        RFunc::Some.new(1).flat_map{|v| RFunc::None.new }.should == RFunc::None.new
      end
    end

    describe "#or_else" do
      context "when the option is a Some" do
        it "returns the option" do
          RFunc::Some.new(1).or_else(RFunc::Some.new(2)).get.should == 1
        end
      end
      context "when the option is a None" do
        context "when the return type of the supplied alternative is valid" do
          it "returns the option" do
            RFunc::None.new.or_else(RFunc::Some.new(2)).get.should == 2
          end
        end
        context "when the return type of the supplied alternative is invalid" do
          it "raises an exception" do
            expect {
              RFunc::None.new.or_else(2).get.should == 2
            }.to raise_error(RFunc::Errors::InvalidReturnType)
          end
        end
      end
    end
  end
end