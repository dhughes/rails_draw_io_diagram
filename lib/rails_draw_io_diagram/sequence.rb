module RailsDrawIoDiagram
  class Sequence

    @@id = 0

    def self.next_id
      @@id += 1
    end

    def self.reset
      @@id = 0
      @@root_id = nil
      @@base_parent_id = nil
    end

    def self.current_id
      @@id
    end

    def self.root_id
      @@root_id ||= next_id
    end

    def self.base_parent_id
      @@base_parent_id ||= next_id
    end
  end
end
