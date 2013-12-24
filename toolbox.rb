module Sokoban
  class ToolBox
    attr_accessor :tools, :position, :padding, :caption, :clicked_tool

    def initialize(caption, window, position = Position.new, padding = 15, clicked_tool = 0)
      @tools = []
      @caption = caption
      @window = window
      @position = position
      @padding = padding
      @clicked_tool = clicked_tool
    end

    def add_tool(tool)
      @tools << tool
    end

    def width
      0 if @tools.empty?
      return @tools[0].picture.full_width if @tools.size == 1
      @padding + 2 * @tools[0].picture.full_width
    end

    def height
      0 if @tools.empty?
      column_size = @tools.size.even? ? @tools.size / 2 : @tools.size / 2.0 + 0.5
      column_size * @padding + column_size * @tools[0].picture.full_height + 10
    end

    def draw_border
      Border.new(@window, Position.new(@position.x, @position.y), Position.new(@position.x + width, @position.y + height), 15).draw
    end

    def display
      @tools.each { |tool| tool.picture.path = tool.load_paths[0] }
      @tools[@clicked_tool].picture.path = @tools[@clicked_tool].load_paths[1]
      @caption.move @position.x + width / 2 - 40, @position.y - 5
      current_y = @position.y + 10
      @tools.each_slice(2) do |tool_slice|
        tool_slice[0].picture.move @position.x, current_y + @padding
        tool_slice[1].picture.move @position.x + tool_slice[0].picture.full_width + @padding, current_y + @padding if tool_slice[1] != nil
        current_y += tool_slice[0].picture.full_height + @padding
      end
      draw_border
    end
  end
end