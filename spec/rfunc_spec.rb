require 'spec_helper'

describe RFunc do
  it "allows for testing" do
    RFunc::Seq.new([1,2,3]).map {|v| v * 2}.should eq([2, 4, 6])
  end
end