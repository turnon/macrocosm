require 'erb'

class Macrocosm

  class Template

    class Position
      attr_reader :name

      def initialize(name)
        @name = name
      end

      def regexp
        @regexp ||= Regexp.new("\\/\\*.*?start-#{name}.*?\\*\\/(.*)\\/\\*.*?end-#{name}.*?\\*\\/", Regexp::MULTILINE)
      end

      def mark
        "<%= #{name} %>"
      end

      def default_value
        @default_value ||= Raw.match(regexp)[1]
      end
    end

    Raw = File.read(File.join(__dir__, 'template.html'))

    Positions = []

    Raw.scan(/\/\*.*?start-.*?\*\//).each do |s|
      name = s.match(/-(.+)\s+\*/)[1]
      pos = Position.new(name)
      Positions << pos

      define_method(name) do
        binding_values[name.to_sym] || pos.default_value
      end
    end

    Engine = ERB.new(Positions.reduce(Raw){ |file, pos| file.sub(pos.regexp, pos.mark) })

    Css = '<style>' + File.read(File.join(__dir__, 'frontend', 'iview.4.3.2.css')) + '</style>'

    Js = ['vue.2.6.12.min.js', 'iview.min.js', 'echarts.4.8.0.min.js', 'vue-echarts.4.0.2.min.js'].each_with_object([]) do |file, arr|
      code = File.read(File.join(__dir__, 'frontend', file))
      arr << '<script>' << code << '</script>'
    end.join

    attr_reader :binding_values

    def initialize(binding_values)
      @binding_values = {css: false, js: Js}.merge(binding_values)
    end

    def render
      Engine.result(binding)
    end
  end

end
