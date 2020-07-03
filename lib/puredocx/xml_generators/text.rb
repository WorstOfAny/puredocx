require 'cgi'

module PureDocx
  module XmlGenerators
    class Text < Base
      DEFAULT_TEXT_SIZE  = 28
      DEFAULT_TEXT_ALIGN = 'left'.freeze
      DEFAULT_TEXT_UNDERLINE = 'none'.freeze

      attr_reader :bold_enable, :italic_enable, :align, :size, :underline, :list_property, :left_indent, :color

      def initialize(content, rels_constructor, arguments = {})
        super(nil, rels_constructor)
        @content       = CGI.escapeHTML(content)
        @bold_enable   = [*arguments[:style]].include?(:bold)
        @italic_enable = [*arguments[:style]].include?(:italic)
        @align         = arguments[:align]     || DEFAULT_TEXT_ALIGN
        @size          = arguments[:size]      || DEFAULT_TEXT_SIZE
        @underline     = arguments[:underline] || DEFAULT_TEXT_UNDERLINE
        @list_property = arguments[:list_property]
        @left_indent   = arguments[:left_indent]
        @color         = arguments[:color]
      end

      def params
        {
          '{TEXT}'          => content,
          '{ALIGN}'         => align,
          '{BOLD_ENABLE}'   => bold_enable,
          '{ITALIC_ENABLE}' => italic_enable,
          '{SIZE}'          => size,
          '{UNDERLINE}'     => underline,
          '{LIST_PROPERTY}' => list_property,
          '{LEFT_INDENT}'   => left_indent,
          '{COLOR}'         => color,
        }
      end

      def template
        File.read(DocArchive.template_path('paragraph.xml'))
      end
    end
  end
end
