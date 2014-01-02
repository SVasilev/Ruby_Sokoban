module Sokoban
  class DropdownMenu
    attr_reader :menu
    def initialize(window, caption, options = [], position = Position.new)
      @window   = window
      @caption  = caption
      @options  = options
      @position = position
      background_line
      @menu = window.stack left: position.x, top: position.y, margin: 0 do
        window.stack { window.para(caption).style size: 10, margin: 1 }
        options.each { |element| window.stack { window.para(element).style size: 10, fill: "BBBBBB", margin: 0 }.toggle }
      end

      adjust_width
      menu_hover_leave
      menu_click
    end

    def background_line
      text = ""
      1000.times { text << " " }
      @window.para(text).style width: 1000, fill: "BBBBBB", size: 12, margin: 0
    end

    def adjust_width
      @window.start do 
        @menu.width = find_max_width
        make_width_equal
      end
    end

    def menu_hover_leave
      @menu.contents.each do |stack|
        stack.hover { stack.contents[0].style stroke: "FFFFFF", fill: "0000FF" }
      end

      @menu.contents.each do |stack|
        stack.leave { stack.contents[0].style stroke: "000000", fill: "BBBBBB" }
      end
    end

    def menu_click
      @menu.contents[0].click do
        toggle_menu
      end
      @menu.contents.each_index do |index|
        unless index == 0
          @menu.contents[index].click do
            toggle_menu
          end
        end
      end
    end

    def toggle_menu
      @menu.contents.each_index { |index| @menu.contents[index].toggle if index != 0 }
    end

    def find_max_width
      toggle_menu
      max_width = @menu.contents.map { |stack| stack.contents[0].width }.max
      toggle_menu
      max_width + 2
    end

    def not_equal?(width)
      @menu.contents.each_index do |index|
        return true if @menu.contents[index].contents[0].width < width and index != 0
      end
      false
    end

    def make_width_equal
      toggle_menu
      max_width = find_max_width
      while not_equal? max_width
        @menu.contents.each_index do |index|
          if @menu.contents[index].contents[0].width < max_width and index != 0
            @menu.contents[index].contents[0].text = @menu.contents[index].contents[0].text << " " 
          end
        end
      end
      toggle_menu
    end
  end
end