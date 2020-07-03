module PureDocx
  module XmlGenerators
    class Table < Base
      WITHOUT_BORDER_VALUES = { value: '',   default_value: 'single' }.freeze
      BOLD_BORDER_VALUES    = { value: '18', default_value: '4' }.freeze
      attr_reader :table_content,
                  :columns_count,
                  :sides_without_border,
                  :bold_sides,
                  :received_table_width,
                  :received_col_width

      def initialize(table_content, _rels_constructor, arguments = {})
        @table_content        = table_content || []
        @columns_count        = table_content[0].size
        @received_table_width = arguments[:table_width]
        @received_col_width   = arguments[:col_width]
        @sides_without_border = prepare_sides(WITHOUT_BORDER_VALUES, arguments[:sides_without_border])
        @bold_sides           = prepare_sides(BOLD_BORDER_VALUES,    arguments[:bold_sides])
        @paddings             = arguments[:paddings] || {}
      end

      def template
        File.read(DocArchive.template_path('table/table.xml'))
      end

      def params
        {
          '{TABLE_WIDTH_VALUE}'          => table_width[:value],
          '{TABLE_WIDTH_TYPE}'           => table_width[:type],
          '{PADDING_TOP}'                => @paddings.fetch(:top,    0),
          '{PADDING_BOTTOM}'             => @paddings.fetch(:bottom, 0),
          '{PADDING_LEFT}'               => @paddings.fetch(:left,   0),
          '{PADDING_RIGHT}'              => @paddings.fetch(:right,  0),
          '{BORDER_TOP}'                 => sides_without_border[:top],
          '{BORDER_BOTTOM}'              => sides_without_border[:bottom],
          '{BORDER_LEFT}'                => sides_without_border[:left],
          '{BORDER_RIGHT}'               => sides_without_border[:right],
          '{BORDER_INSIDE_H}'            => sides_without_border[:inside_h],
          '{BORDER_INSIDE_V}'            => sides_without_border[:inside_v],
          '{BORDER_TOP_SIZE}'            => bold_sides[:top],
          '{BORDER_BOTTOM_SIZE}'         => bold_sides[:bottom],
          '{BORDER_LEFT_SIZE}'           => bold_sides[:left],
          '{BORDER_RIGHT_SIZE}'          => bold_sides[:right],
          '{BORDER_INSIDE_H_SIZE}'       => bold_sides[:inside_h],
          '{BORDER_INSIDE_V_SIZE}'       => bold_sides[:inside_v],
          '{GRID_OPTIONS}'               => '',
          '{ROWS}'                       => rows
        }
      end

      private

      def rows
        table_content.map do |row_content|
          PureDocx::XmlGenerators::Row.new(row_content, nil).xml
        end.join
      end

      def table_builder
        @table_builder ||= PureDocx::Constructors::TableColumn.new(
          received_table_width,
          received_col_width,
          columns_count
        )
      end

      def columns_width
        table_builder.columns_width
      end

      def table_width
        table_builder.table_width
      end

      def prepare_sides(border_type_value, params = [])
        %i[right left top bottom inside_h inside_v].map do |item|
          [item, params&.include?(item) ? border_type_value[:value] : border_type_value[:default_value]]
        end.to_h
      end
    end
  end
end
