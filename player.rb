module Sokoban
  class Player
    attr_accessor :index

    def initialize(window, ground, picture_path = "", position = Position.new)
      @ground   = ground
      @index    = 0
      @position = position
      @picture  = window.image picture_path
      @picture.move @position.x, @position.y
    end

    def move(direction)
      case direction
      when :left
        unless @position.x == @ground.position.x
          @position.x = @position.x - @picture.full_width
          @picture.move @position.x, @position.y
          @index -= 1
        end
      when :right
        unless @position.x == (@ground.position.x + @ground.width_in_pxels - @picture.full_width)
          @position.x = @position.x + @picture.full_width
          @picture.move @position.x, @position.y
          @index += 1
        end
      when :up
        unless @position.y == @ground.position.y
          @position.y = @position.y - @picture.full_height
          @picture.move @position.x, @position.y
          @index -= @ground.width
        end
      when :down
        unless @position.y == (@ground.position.y + @ground.height_in_pixels - @picture.full_height)
          @position.y = @position.y + @picture.full_height
          @picture.move @position.x, @position.y
          @index += @ground.width
        end
      end
    end
  end
end