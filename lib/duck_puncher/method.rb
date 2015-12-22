module DuckPuncher
  module Method
    def to_instruct
      definition = Definition.new(self)
      RubyVM::InstructionSequence.new(definition.lines.join).disasm if definition.lines.any?
    end

    class Definition
      def initialize(method_handle)
        @file_path, @line_num = *method_handle.source_location
        @line_num = @line_num.to_i
      end

      # @description finds the method's source code using the indent size of the file. This means we are
      # restricted when it comes to parsing crappy formatted ruby files
      def lines
        return @lines if defined? @lines
        return [] unless @file_path
        @lines = []
        File.open(@file_path) do |f|
          found = false
          i = 0
          while line = f.gets and i += 1 and !found
            next if i < @line_num
            @lines << line
            if @indent_size
              found = @indent_size == find_indent_size(line)
            else
              @indent_size = find_indent_size(line)
              found = line.end_with?("end\n")
            end
          end
        end
        @lines
      end

      def find_indent_size(line)
        line[/(\s*)/].size
      end
    end
  end
end

Method.send(:include, DuckPuncher::Method)
