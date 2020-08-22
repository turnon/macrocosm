require 'erb'

class Macrocosm

  class Template

    class Position
      attr_reader :name

      def initialize(name)
        @name = name
      end

      def regexp
        @regexp ||= Regexp.new("\\/\\*.*?start-#{name}.*end-#{name}.*?\\*\\/", Regexp::MULTILINE)
      end

      def mark
        "<%= #{name} %>"
      end
    end

    attr_reader :raw

    def initialize
      @raw = File.read(File.join(__dir__, 'template.html'))
    end

    def positions
      @positions ||= @raw.scan(/\/\*.*?start-.*?\*\//).map do |s|
        name = s.match(/-(.+)\s+\*/)[1]
        Position.new(name)
      end
    end

    def erb
      return @erb if @erb
      file = positions.reduce(@raw) do |file, pos|
        file.sub(pos.regexp, pos.mark)
      end
      @erb = ERB.new(file)
    end

    def render(b)
      erb.result(b)
    end
  end

end
