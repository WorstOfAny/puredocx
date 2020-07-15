require 'cgi'

module PureDocx
  module XmlGenerators
    class List < Base
      attr_reader :new, :type, :lvl, :list_params, :arguments

      def initialize(content, rels_constructor, arguments = {})
        super(nil, rels_constructor)
        @content     = CGI.escapeHTML(content)
        @type        = arguments.fetch(:type_id, 1)
        @lvl         = arguments.fetch(:lvl, 0)
        @list_params = arguments.delete(:list) || {}
        @arguments   = arguments
      end

      def params
        {
					'{LIST_TYPE}' => type,
					'{LIST_LVL}' => lvl,
					'{NUM_ID}' => list_params.fetch(:num_id, 0),
					'{LIST_FORMAT}' => list_params.fetch(:format, 'bullet'),
					'{TYPE_ID}' => list_params.fetch(:type_id, 1),
					'{LVL}' => list_params.fetch(:lvl, 0),
					'{LVL_TEXT}' => list_params.fetch(:lvl_text, '%1.'),
					'{LIST_BOLD_ENABLE}' => list_params.fetch(:bold, false),
					'{LIST_SIZE}' => list_params.fetch(:size, 28)
				}
      end

      def template
        File.read(DocArchive.template_path('list.xml'))
      end

			def list_abstruct_template
				File.read(DocArchive.template_path('word/abstruct_num.xml'))
			end

			def list_num_template
				File.read(DocArchive.template_path('word/num.xml'))
			end

			def xml
				if list_params[:new]
					cont =
						File
							.read(DocArchive.template_path('word/numbering.xml'))
							.sub(/((?<=\>)(?=\<\/w:numbering\>)|(?<=\<\/w:abstractNum\>)\n(?=\<w:num))/, params.each_with_object(list_abstruct_template.clone) { |(param, value), memo| memo.gsub!(param, value.to_s) })
							.sub(/(?=\<\/w:numbering)/, params.each_with_object(list_num_template.clone) { |(param, value), memo| memo.gsub!(param, value.to_s) })
					File.open(DocArchive.template_path('word/numbering.xml'), 'w') {|f|  f.write(cont) }
				end
				XmlGenerators::Text
					.new(self.content, rels_constructor, **arguments, list_property: super)
					.xml
			end
    end
  end
end
