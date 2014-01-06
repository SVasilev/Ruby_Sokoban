module Sokoban
  class Ground
    attr_reader :pictures, :picture_paths, :width, :height, :position
    attr_accessor :picture_indexes
    
    def initialize(window, picture_paths = [], position = Position.new(220, 30), width = 14, height = 10)
      @window = window
      @pictures = []
      @picture_indexes = []
      (width * height).times do 
        @pictures << (window.image picture_paths[4])
        @picture_indexes << [4]
      end
      @picture_paths = picture_paths
      @position = position
      @width = width
      @height = height
      set_pictures
    end

    def picture_index_change(index, value)
      if value == 1 or value == 2 or value == 3
        if (value == 1 and @picture_indexes[index] == [2]) or 
           (value == 2 and @picture_indexes[index] == [1]) or 
           (value == 1 and @picture_indexes[index] == [2, 3])
          @picture_indexes[index] = [1, 2]
        else
          if (value == 2 and @picture_indexes[index] == [3]) or 
             (value == 3 and @picture_indexes[index] == [2]) or 
             (value == 3 and @picture_indexes[index] == [1, 2])
            @picture_indexes[index] = [2, 3]
          else
            @picture_indexes[index] = [value] unless @picture_indexes[index].size == 2
          end
        end
      else
        @picture_indexes[index] = [value]
      end
      value = 5 if @picture_indexes[index] == [1, 2]
      value = 6 if @picture_indexes[index] == [2, 3]
      @pictures[index].path = @picture_paths[value]
    end

    def set_pictures
      current_x, current_y = @position.x, @position.y
      @pictures.each_index do |index|
        @pictures[index].path = @picture_paths[@picture_indexes[index][0]]
        @pictures[index].move current_x, current_y
        current_x += @pictures[index].full_width
        if ((index + 1).remainder @width) == 0
          current_x  = @position.x
          current_y += @pictures[index].full_height
        end
      end
      draw_border
    end

    def width_in_pixels
      @width * @pictures[0].full_width
    end

    def height_in_pixels
      @height * @pictures[0].full_height
    end

    def draw_border
      Border.new(@window, Position.new(@position.x, @position.y), Position.new(@position.x + width_in_pixels, @position.y + height_in_pixels), 15).draw
    end

    def ground_hover?(mouse_left, mouse_top)
      mouse_left > @pictures[0].style[:left] and mouse_top > @pictures[0].style[:top] and
      mouse_left < @pictures.last.style[:left] + @pictures[0].full_width and 
      mouse_top  < @pictures.last.style[:top]  + @pictures[0].full_height
    end

    def picture_hover?(index, mouse_left, mouse_top)
      @pictures[index].style[:left] + @pictures[index].full_width > mouse_left and
      @pictures[index].style[:top] + @pictures[index].full_height > mouse_top
    end

    def picture_index_at(mouse_left, mouse_top)
      return false if !ground_hover? mouse_left, mouse_top
      @pictures.each_index do |index|
        return index if picture_hover? index, mouse_left, mouse_top
      end
    end

    def propriety_check
      warnings = ""
      warnings << "The level doesn't have a start." unless @picture_indexes.include? [3] or @picture_indexes.include? [2, 3]
      if (@picture_indexes.count([1]) != @picture_indexes.count([2]) and @picture_indexes.include?([2, 3]) == false) or
         ((@picture_indexes.count([1]) - 1) != @picture_indexes.count([2]) and @picture_indexes.include? [2, 3])
        warnings << " Cubes don't match the finals count."
      end
      warnings << " There are no cubes." if @picture_indexes.count([1]) == 0 and @picture_indexes.count([1, 2]) == 0
      warnings << " The level is already solved." if @picture_indexes.all? { |element| element != [1] } and warnings == ""
      warnings
    end

    def fix_start
      picture_index_change(@picture_indexes.index([3]), 4) if @picture_indexes.include? [3]
      if @picture_indexes.include? [2, 3]
        @pictures[@picture_indexes.index([2, 3])].path = @picture_paths[2]
        @picture_indexes[@picture_indexes.index([2, 3])] = [2]
      end
    end

    def update(left, top, tool_box)
      fix_start if tool_box.clicked_tool == 3
      picture_index_change picture_index_at(left, top), tool_box.clicked_tool
    end

    def clear
      @pictures.each_index { |index| picture_index_change index, 4 }
    end
  end
end