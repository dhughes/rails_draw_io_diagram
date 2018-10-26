module RailsDrawIoDiagram
  class Sequence

    @@id = 0

    def self.next_id
      @@id += 1
    end

    def self.reset
      @@id = 0
    end
  end
end
