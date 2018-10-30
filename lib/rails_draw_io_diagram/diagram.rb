require 'nokogiri'

module RailsDrawIoDiagram
  class Diagram
    attr_accessor :diagram, :root, :models

    def initialize(models:)
      load_models(models)
    end

    def database_xml
      document = Nokogiri::XML::Document.parse('')

      builder = Nokogiri::XML::Builder.with(document) do |xml|
        xml.mxGraphModel do
          xml.root do
            xml.mxCell(id: RailsDrawIoDiagram::Sequence.root_id)
            xml.mxCell(id: RailsDrawIoDiagram::Sequence.base_parent_id, parent: RailsDrawIoDiagram::Sequence.root_id)

            models.each do |model|
              xml.parent << model.to_xml
            end
          end
        end
      end

      URI::encode(builder.to_xml)
    end

    private

    def add_model(model)
      model_cell = add_cell(root, id: model.id, value: model.table_name, style: title_style, vertex: 1, parent: Sequence.base_parent_id)
      add_geometry(model_cell, 0, 0, 240, (model.fields.size + 1) * 30)

      add_fields(model)
    end

    def add_fields(model)
      model.fields.each do |field|

      end
    end

    def add_geometry(parent, x, y, width, height)
      parent.add_child(create_mx_geometry(x, y, width, height))
    end

    def add_required
      add_cell(root, id: RailsDrawIoDiagram::Sequence.root_id)
      add_cell(root, id: RailsDrawIoDiagram::Sequence.base_parent_id, parent: RailsDrawIoDiagram::Sequence.root_id)
    end

    def add_cell(parent, attributes)
      parent.add_child(create_mx_cell(attributes))
    end

    def create_mx_geometry(x, y, width, height)
      diagram.create_element('mxGeometry', x: x, y: y, width: width, height: height, as: 'geometry')
    end

    def create_mx_cell(attributes)
      diagram.create_element('mxCell', attributes)
    end

    def reset_diagram
      @diagram = Nokogiri::XML('')
      @root = mx_graph_model.add_child(diagram.create_element('root'))
    end

    def mx_graph_model
      @mx_graph_model ||= diagram.add_child(diagram.create_element('mxGraphModel'))
    end

    def models
      RailsDrawIoDiagram::ModelRegistry.models
    end

    def load_models(models)
      models.each do |model|
        RailsDrawIoDiagram::Model.new(model: model)
      end
    end

    def id_field_style
      'shape=partialRectangle;top=0;left=0;right=0;bottom=1;align=left;verticalAlign=middle;fillColor=none;spacingLeft=34;spacingRight=4;overflow=hidden;rotatable=0;points=[[0,0.5],[1,0.5]];portConstraint=eastwest;dropTarget=0;fontStyle=5;'
    end

  end
end
