module RailsDrawIoDiagram
  class Model
    attr_accessor :id, :model

    FIELD_HEIGHT = 30
    MODEL_WIDTH = 240

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
        RailsDrawIoDiagram::Field.new(field_name: column_name, model: self)
      end
    end

    def field(field_name)
      fields.detect { |field| field.field_name == field_name }
    end

    def foreign_keys
      @foreign_keys ||= begin
        belongs_tos.map do |belongs_to|
          if belongs_to.polymorphic?
            ModelRegistry.models.
              map do |to_model|
                activerecord_model = to_model.model
                activerecord_model.reflect_on_all_associations(:has_many).
                  select { |association| association.plural_name == model.model_name.plural && association.options[:as] == belongs_to.name }.
                  map do |association|
                    RailsDrawIoDiagram::ForeignKey.new(
                      from_field: field(belongs_to.foreign_key),
                      to_field: to_model.field(to_model.model.primary_key)
                    )
                  end
                end
          else
            to_model = RailsDrawIoDiagram::ModelRegistry.model(belongs_to.class_name)
            RailsDrawIoDiagram::ForeignKey.new(
              from_field: field(belongs_to.foreign_key),
              to_field: to_model.field(to_model.model.primary_key)
            )
          end
        end.flatten
      end
    end

    def foreign_key(field_name)
      foreign_keys.detect { |foreign_key| foreign_key.from_field.field_name == field_name }
    end

    def to_xml
      fragment = Nokogiri::XML::DocumentFragment.parse('')

      Nokogiri::XML::Builder.with(fragment) do |fragment|
        fragment.mxCell(id: id, value: table_name, style: title_style, vertex: 1, parent: Sequence.base_parent_id) do
          fragment.mxGeometry(x: (id * 240 + (id * 80)) - 320, y: 0, width: MODEL_WIDTH, height: height, as: 'geometry')
        end

        fields.each_with_index do |field, index|
          fragment.mxCell(id: field.id, value: field.field_name, style: field_style, vertex: 1, parent: id) do
            fragment.mxGeometry(y: (index + 1) * 30, height: FIELD_HEIGHT, as: 'geometry')
          end
          fragment.mxCell(id: Sequence.next_id, value: field.key_type, style: key_style, vertex: 1, connectable: 0, parent: field.id) do
            fragment.mxGeometry(width: FIELD_HEIGHT, height: FIELD_HEIGHT, as: 'geometry')
          end
        end

        foreign_keys.each do |foreign_key|
          fragment.mxCell(id: foreign_key.id, style: line_style, edge: 1, source: foreign_key.from_id, target: foreign_key.to_id, parent: 1) do
            fragment.mxGeometry(relative: 1, as: 'geometry')
          end
        end
      end

      fragment
    end

    def height
      (fields.size + 1) * FIELD_HEIGHT
    end

    def leaf?
      foreign_keys.empty?
    end

    private

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

    def line_style
      #color = TableColor.color(to_table)
      "edgeStyle=orthogonalEdgeStyle;html=1;jettySize=auto;orthogonalLoop=1;endArrow=diamond;endFill=1;jumpStyle=gap;strokeColor=#000000;strokeWidth=2;jumpSize=12"
    end
  end
end
