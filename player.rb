module Sokoban
  class Player
    attr_accessor :index

    def initialize(window, ground, picture_path = "", position = Position.new)
      @ground   = ground
      @index    = ground.picture_index_at position.x, position.y
      @position = position
      @picture  = window.image picture_path
      @picture.move @position.x, @position.y
    end

    def valid_move?(index_change)
      return false if @ground.picture_indexes[@index - index_change] == [0]
      if @ground.picture_indexes[@index - index_change].include? 1
        return false if @ground.picture_indexes[@index - 2 * index_change].include? 1 or
                 @ground.picture_indexes[@index - 2 * index_change].include? 0
      end
      true
    end

    def push_cube(index_change)
      if @ground.picture_indexes[@index - index_change].include? 1
        if @ground.picture_indexes[@index - index_change].size == 1
          @ground.picture_index_change @index - index_change, 4
        else
          @ground.pictures[index - index_change].path = @ground.picture_paths[2]
          @ground.picture_indexes[@index - index_change] = [2]
        end
        @ground.picture_index_change @index - 2 * index_change, 1
      end
    end

    def move(direction)
      #These long lines should be fixed.
      case direction
      when :left
        if @position.x != @ground.position.x and 
           (@position.x - @picture.full_width != @ground.position.x or @ground.picture_indexes[index - 1].include?(1) == false) and valid_move? 1
          @position.x = @position.x - @picture.full_width
          @picture.move @position.x, @position.y
          push_cube 1
          @index -= 1
        end
      when :right
        if @position.x != (@ground.position.x + @ground.width_in_pixels - @picture.full_width) and 
           (@position.x + 2 * @picture.full_width != @ground.position.x + @ground.width_in_pixels or @ground.picture_indexes[index + 1].include?(1) == false) and valid_move? -1
          @position.x = @position.x + @picture.full_width
          @picture.move @position.x, @position.y
          push_cube -1
          @index += 1
        end
      when :up
        if @position.y != @ground.position.y and 
           (@position.y - @picture.full_height != @ground.position.y or @ground.picture_indexes[index - @ground.width].include?(1) == false) and valid_move? @ground.width
          @position.y = @position.y - @picture.full_height
          @picture.move @position.x, @position.y
          push_cube @ground.width
          @index -= @ground.width
        end
      when :down
        if @position.y != (@ground.position.y + @ground.height_in_pixels - @picture.full_height) and 
           (@position.y + @picture.full_height != @ground.position.y or @ground.picture_indexes[index + @ground.width].include?(1) == false) and valid_move? -@ground.width
          @position.y = @position.y + @picture.full_height
          @picture.move @position.x, @position.y
          push_cube -@ground.width
          @index += @ground.width
        end
      end
    end

    def clear
      @picture.path = ""
    end
  end
end