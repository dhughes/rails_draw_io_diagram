require 'nokogiri'

module RailsDrawIoDiagram
  class Diagram
    attr_accessor :diagram

    def initialize(models:)
      @reference_models = models
      @diagram = Nokogiri::XML('')
    end

    def database_xml
      reset_root
      add_required

      models.each do |model|
        add_model(model)
      end

      binding.pry
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.mxGraphModel do
          xml.root do
            xml.mxCell(id: RailsDrawIoDiagram::Sequence.root_id)
            xml.mxCell(id: RailsDrawIoDiagram::Sequence.base_parent_id, parent: RailsDrawIoDiagram::Sequence.root_id)

            models.each do |model|
              xml.mxCell(id: model.id, value: model.table_name, style: title_style, vertex: 1, parent: Sequence.base_parent_id) do
                xml.mxGeometry(x: 0, y: 0, width: 240, height: (model.fields.size + 1) * 30, as: 'geometry')
              end

              model.fields.each_with_index do |field, index|
                xml.mxCell(id: field.id, value: field.field_name, style: field_style, vertex: 1, parent: model.id) do
                  xml.mxGeometry(y: (index + 1) * 30, width: 240, height: 30, as: 'geometry')
                end
                xml.mxCell(id: Sequence.next_id, value: '??', style: key_style, vertex: 1, connectable: 0, parent: field.id) do
                  xml.mxGeometry(width: 30, height: 30, as: 'geometry')
                end
              end

            end

          end
        end
      end

      URI::encode(builder.doc.root.to_xml)
    end

    private

    def add_model(model)
      title_cell = add_root_cell(id: model.id, value: model.table_name, style: title_style, vertex: 1, parent: Sequence.base_parent_id)
      # TODO: add gometry
    end

    def add_cell_with_geometry(cell, geometry)

    end

    def add_required
      add_root_cell(id: RailsDrawIoDiagram::Sequence.root_id)
      add_root_cell(id: RailsDrawIoDiagram::Sequence.base_parent_id, parent: RailsDrawIoDiagram::Sequence.root_id)
    end

    def add_root_cell(attributes)
      root.add_child(mx_cell(attributes))
    end

    def mx_cell(attributes)
      diagram.create_element('mxCell', attributes)
    end

    def root
      @root ||= reset_root
    end

    def reset_root
      @root = mx_graph_model.add_child(diagram.create_element('root'))
    end

    def mx_graph_model
      @mx_graph_model ||= diagram.add_child(diagram.create_element('mxGraphModel'))
    end

    def models
      @models ||= begin
        @reference_models.each do |model|
          RailsDrawIoDiagram::ModelRegistry.add(
            RailsDrawIoDiagram::Model.new(model: model)
          )
        end
        RailsDrawIoDiagram::ModelRegistry.models
      end
    end

    def title_style
      "swimlane;fontStyle=0;childLayout=stackLayout;horizontal=1;startSize=26;fillColor=#FFFFFF;horizontalStack=0;resizeParent=1;resizeParentMax=0;resizeLast=0;collapsible=1;marginBottom=0;swimlaneFillColor=#ffffff;align=center;rounded=0;strokeColor=#000000;"
    end

    def id_field_style
      'shape=partialRectangle;top=0;left=0;right=0;bottom=1;align=left;verticalAlign=middle;fillColor=none;spacingLeft=34;spacingRight=4;overflow=hidden;rotatable=0;points=[[0,0.5],[1,0.5]];portConstraint=eastwest;dropTarget=0;fontStyle=5;'
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
