module Sokoban
  class Menu
    attr_reader :stack
    def initialize(window, stack, button_texts = [], position = Position.new, width = 122, button_height = 50, bottom_margin = 10)
      @window = window
      @stack = stack
      @button_texts = button_texts
      @position = position
      @width = width
      @button_height = button_height
      @bottom_margin = bottom_margin
    end

    def draw_border
      Border.new(@window, Position.new(@position.x, @position.y), Position.new(@position.x + @width, @position.y + height), 15).draw
    end

    def height
      #It looks like Shoes! has some problem setting the button height... So the real height of a button is real_height = button_height - 18.
      button_height_fix = 18
      @button_texts.size * (@button_height - button_height_fix + @bottom_margin)
    end

    def display
      @stack.style left: @position.x, top: @position.y, width: @width, height: height
      @button_texts.each do |text| 
        @stack.button(text).style width: @width, height: @button_height, margin_bottom: @bottom_margin
      end
      draw_border
    end
  end
end