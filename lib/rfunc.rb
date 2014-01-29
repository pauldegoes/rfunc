require "rfunc/version"
require "rfunc/option"
require "rfunc/seq"


module RFunc
  module_function

  def seq(a); RFunc::Seq.new(a) end

  def option(v); RFunc::Option.new(v) end

  def some(v); RFunc::Some.new(v) end

  def none; RFunc::None.new end
end
