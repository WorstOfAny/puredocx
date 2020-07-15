module PureDocx
  module XmlGenerators
    class Cell < Base
      attr_reader :width, :v_align

      def initialize(content, rels_constructor, arguments = {})
        super(content, rels_constructor)
        @width = arguments[:width]
        @v_align = content[:v_align] || arguments[:v_align] || 'top'
        @cell_merge = content[:cell_merge]
      end

      def template
        File.read(DocArchive.template_path('table/cells.xml'))
      end

      def params
        {
          '{CONTENT}'      => content[:column].map(&:chomp).join,
          '{WIDTH}'        => width,
          '{V_ALIGN}'      => v_align,
          '{CELL_MERGE}'   => cell_merge
        }
      end

      private

      def cell_merge
				@cell_merge ? %{<w:vMerge w:val="#{@cell_merge}"/>} : ''
			end
    end
  end
end
