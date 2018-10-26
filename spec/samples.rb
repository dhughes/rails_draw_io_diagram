# frozen_string_literal: true

module Samples

  def samples
    Content.new
  end

  class Content

    FIXTURES_PATH = 'fixtures'

    def method_missing(method_name, *arguments, &block)
      if respond_to_missing?(method_name)
        File.read(File.join(this_directory, FIXTURES_PATH, "#{method_name.to_s}.txt"))
      else
        super
      end
    end

    def respond_to_missing?(method_name, include_private = false)
      fixtures.include?(method_name) || super
    end

    private

    def fixtures
      Dir[File.join(this_directory, FIXTURES_PATH, '*.txt')].map { |path| File.basename(path, '.txt').to_sym }
    end

    def this_directory
      File.dirname(__FILE__)
    end
  end


end
