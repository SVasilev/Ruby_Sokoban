module Sokoban
  class Border
    attr_reader :padding
    
    def initialize(window, top_left = Position.new, bottom_right = Position.new, padding = 0, color = "AAA", width = 2)
      @window = window
      @top_left = top_left
      @bottom_right = bottom_right
      @padding = padding
      @color = color
      @width = width
    end

    def top_right
      Position.new @bottom_right.x, @top_left.y
    end

    def bottom_left
      Position.new @top_left.x, @bottom_right.y
    end

    def draw
      @window.stroke @color
      @window.strokewidth @width
      @window.line @top_left.x - padding, @top_left.y - padding, top_right.x + padding, top_right.y - padding
      @window.line @top_left.x - padding, @top_left.y - padding, bottom_left.x - padding, bottom_left.y + padding
      @window.line bottom_left.x - padding, bottom_left.y + padding, @bottom_right.x + padding, @bottom_right.y + padding
      @window.line top_right.x + padding, top_right.y - padding, @bottom_right.x + padding, @bottom_right.y + padding
    end
  end
end