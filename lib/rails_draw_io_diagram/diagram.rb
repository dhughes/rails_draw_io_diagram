require 'nokogiri'

module RailsDrawIoDiagram
  class Diagram
    attr_accessor :diagram, :root, :models

    def initialize(models:)
      load_models(models)
    end

    def database_xml
      # LayoutService.new(models: models).layout_diagram

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

    def models
      RailsDrawIoDiagram::ModelRegistry.models
    end

    def load_models(models)
      models.each do |model|
        RailsDrawIoDiagram::Model.new(model: model)
      end
    end
  end
end
