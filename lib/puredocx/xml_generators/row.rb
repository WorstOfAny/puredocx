module PureDocx
  module XmlGenerators
    class Row < Base
      attr_reader :cells_width, :cell_v_align

      def initialize(content, rels_constructor, arguments = {})
        super(content, rels_constructor)
        @cells_width  = arguments[:cells_width]
        @cell_v_align = arguments[:cell_v_align]
      end

      def template
        File.read(DocArchive.template_path('table/rows.xml'))
      end

      def params
        { '{CELLS}' => cells }
      end

      private

      def cells
        content.each_with_index.map do |cell_content, index|
          PureDocx::XmlGenerators::Cell.new(cell_content, nil, width: cells_width[index], v_align: cell_v_align).xml
        end.join
      end
    end
  end
end
