module RailsDrawIoDiagram
  class Model
    attr_accessor :id, :model

    def initialize(model:)
      @id = RailsDrawIoDiagram::Sequence.next_id
      @model = model
      RailsDrawIoDiagram::ModelRegistry.add(self)
    end

    def class_name
      model.name
    end

    def table_name
      model.table_name
    end

    def fields
      @fields ||= model.column_names.map do |column_name|
        RailsDrawIoDiagram::Field.new(field_name: column_name, model: self, foreign_key: foreign_key_field_names.include?(column_name))
      end
    end

    def field(field_name)
      fields.detect { |field| field.field_name == field_name }
    end

    def foreign_keys
      @foreign_keys ||= belongs_tos.map do |belongs_to|
        RailsDrawIoDiagram::ForeignKey.new(
          from_field: field(belongs_to.foreign_key),
          to_field: RailsDrawIoDiagram::ModelRegistry.model(belongs_to.class_name).field('id')
        )
      end
    end

    def to_xml
      fragment = Nokogiri::XML::DocumentFragment.parse('')

      Nokogiri::XML::Builder.with(fragment) do |fragment|
        fragment.mxCell(id: id, value: table_name, style: title_style, vertex: 1, parent: Sequence.base_parent_id) do
          fragment.mxGeometry(x: 0, y: 0, width: 240, height: (fields.size + 1) * 30, as: 'geometry')
        end

        fields.each_with_index do |field, index|
          fragment.mxCell(id: field.id, value: field.field_name, style: field_style, vertex: 1, parent: id) do
            fragment.mxGeometry(y: (index + 1) * 30, width: 240, height: 30, as: 'geometry')
          end
          fragment.mxCell(id: Sequence.next_id, value: field.key_type, style: key_style, vertex: 1, connectable: 0, parent: field.id) do
            fragment.mxGeometry(width: 30, height: 30, as: 'geometry')
          end
        end
      end

      fragment
    end

    private

    def foreign_key_field_names
      belongs_tos.map(&:foreign_key)
    end

    def belongs_tos
      model.reflect_on_all_associations(:belongs_to)
    end

    def title_style
      "swimlane;fontStyle=0;childLayout=stackLayout;horizontal=1;startSize=26;fillColor=#FFFFFF;horizontalStack=0;resizeParent=1;resizeParentMax=0;resizeLast=0;collapsible=1;marginBottom=0;swimlaneFillColor=#ffffff;align=center;rounded=0;strokeColor=#000000;"
    end

    def field_style #(column_type)
      # font_color = 'none'
      # font_style = '0'
      # font_color = '#004C99' if column_type == 'rk'
      # font_style = '1' if column_type == 'rk'
      "shape=partialRectangle;top=0;left=0;right=0;bottom=0;align=left;verticalAlign=top;fillColor=none;spacingLeft=34;spacingRight=4;overflow=hidden;rotatable=0;points=[[0,0.5],[1,0.5]];portConstraint=eastwest;dropTarget=0;fontColor=#000000;fontStyle=0"
    end

    def key_style #(color)
      "shape=partialRectangle;top=0;left=0;bottom=0;align=left;fill_color=#FFFFFF;verticalAlign=middle;spacingLeft=4;spacingRight=4;overflow=hidden;rotatable=0;points=[];portConstraint=eastwest;part=1;fillColor=none;strokeColor=#000000;"
    end
  end
end
