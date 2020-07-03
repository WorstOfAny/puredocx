module PureDocx
  module XmlGenerators
    class Cell < Base
			DEFAULT_WIDTH = {
				type: 'dxa',
				value: '1000'
			}

      attr_reader :width, :align, :color

      def initialize(content, rels_constructor, arguments = {})
        super(content, rels_constructor)
        @width = content.fetch(:width, DEFAULT_WIDTH)
        @align = content[:align]
        @color = content.fetch(:color, 'ffffff')
      end

      def template
        File.read(DocArchive.template_path('table/cells.xml'))
      end

      def params
        {
          '{CONTENT}'      => content[:column].map(&:chomp).join,
          '{WIDTH_TYPE}'   => width[:type],
          '{WIDTH_VALUE}'  => width[:value],
          '{ALIGN}'        => align,
          '{COLOR}'        => color
        }
      end
    end
  end
end
