require "rfunc/version"
require "rfunc/option"
require "rfunc/seq"
require "rfunc/errors"


module RFunc
  module_function

  def Seq(a); RFunc::Seq.new(a) end

  def Option(v); RFunc::Option.new(v) end

  def Some(v); RFunc::Some.new(v) end

  def None; RFunc::None.new end
end
