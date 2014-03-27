module RFunc
  module Errors
    class InvalidReturnType < ArgumentError
      def initialize(o,expected_type)
        super("Invalid Return type for #{o.class}.  Expected #{expected_type}")
      end
    end
  end
end