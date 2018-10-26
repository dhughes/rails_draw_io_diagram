module RailsDrawIoDiagram
  class ForeignKey
    attr_accessor :id, :from_field, :to_field

    def initialize(from_field:, to_field:)
      @id = RailsDrawIoDiagram::Sequence.next_id
      @from_field = from_field
      @to_field = to_field
    end
  end
end
