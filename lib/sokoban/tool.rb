module Sokoban
  class Tool
    attr_accessor :picture, :load_paths

    def initialize(picture, paths)
      @picture = picture
      @load_paths = paths
    end
  end
end