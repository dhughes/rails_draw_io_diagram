module RailsDrawIoDiagram
  class Field
    attr_accessor :id, :field_name, :model

    def initialize(field_name:, model:)
      @id = RailsDrawIoDiagram::Sequence.next_id
      @field_name = field_name
      @model = model
    end

  end
end
