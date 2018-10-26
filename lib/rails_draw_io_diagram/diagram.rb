require 'nokogiri'

module RailsDrawIoDiagram
  class Diagram
    def initialize(models:)
      @reference_models = models
    end

    def database_xml
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.mxGraphModel do
          xml.root do
            xml.mxCell(id: RailsDrawIoDiagram::Sequence.root_id)
            xml.mxCell(id: RailsDrawIoDiagram::Sequence.base_parent_id, parent: RailsDrawIoDiagram::Sequence.root_id)

            models.each do |model|
              binding.pry
            end


          end
        end
      end

      URI::encode(builder.doc.root.to_xml)
    end

    private

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

    # def models
    #   RailsDrawIoDiagram::ModelRegistry.models
    # end

  end
end
