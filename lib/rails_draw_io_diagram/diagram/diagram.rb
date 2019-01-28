require 'nokogiri'

module RailsDrawIoDiagram
  module Diagram
    class Diagram
      attr_accessor :diagram, :root, :models

      CELL_MINIMUM_DISTANCE = 80

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

      def minimum_cell_length
        # iterate over all models and find the minimum width
        [models.map(&:width).min, models.map(&:height).min].min + CELL_MINIMUM_DISTANCE
      end

      def maximum_cell_length
        # iterate over all models and find the minimum width
        [models.map(&:width).max, models.map(&:height).max].max + CELL_MINIMUM_DISTANCE
      end

      def grid_cell_size
        if maximum_cell_length < 3 * minimum_cell_length
          maximum_cell_length
        elsif 3 * minimum_cell_length <= maximum_cell_length && maximum_cell_length < 15 * minimum_cell_length
          (3 * minimum_cell_length) / 2
        elsif 15 * minimum_cell_length <= maximum_cell_length
          maximum_cell_length / 30
        end
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
end
