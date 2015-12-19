module DuckPuncher
  module Method
    def to_instruct
      RubyVM::InstructionSequence.new(source).disasm
    end
  end
end

Method.send(:include, DuckPuncher::Method)
