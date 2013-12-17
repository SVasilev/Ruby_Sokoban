#!/usr/bin/env ruby
require 'tk'

class Position
  attr_reader :x, :y
  def initialize(x = 0, y = 0)
    @x = x
    @y = y
  end
end

class Cursor
  def initialize(canvas, color = "black")
    @color = color
    @canvas = canvas
  end
  def display(x = 0, y = 0)
    TkcLine.new(@canvas, 0, 0, 16, 0, 'width' => '10', 'fill' => @color, 'smooth' => true)
    TkcLine.new(@canvas, 0, 16, 0, 0, 'width' => '10', 'fill' => @color, 'smooth' => true)
    TkcLine.new(@canvas, 42, 0, 55, 0, 'width' => '10', 'fill' => @color, 'smooth' => true)
    TkcLine.new(@canvas, 55, 16, 55, 0, 'width' => '3', 'fill' => @color, 'smooth' => true)
    TkcLine.new(@canvas, 0, 52, 16, 52, 'width' => '3', 'fill' => @color, 'smooth' => true)
    TkcLine.new(@canvas, 0, 52, 0, 40, 'width' => '10', 'fill' => @color, 'smooth' => true)
    TkcLine.new(@canvas, 42, 52, 57, 52, 'width' => '3', 'fill' => @color, 'smooth' => true)
    TkcLine.new(@canvas, 55, 40, 55, 52, 'width' => '3', 'fill' => @color, 'smooth' => true)
    @canvas.place('x' => x, 'y' => y)
  end
end

class Tool
  attr_accessor :name, :picture, :clicked_picture

  def initialize(name = "", picture = "", clicked_picture = "")
    @name = name
    @picture = picture
    @clicked_picture = clicked_picture
  end
end

class ToolBox
  attr_accessor :position, :padding

  def initialize(position: Position.new, padding: 20)
    @tools = []
    @position = position
    @padding = padding
    @caption = TkLabel.new { text "Tool box" }
  end

  def add_tool(tool)
    tool_image = TkPhotoImage.new
    tool_image.file = tool.picture
    @tools << TkLabel.new { image tool_image }
  end

  def width
    return 0 if @tools.empty?
    return 2 * @position.x + 2 * @padding + @tools[0].image.width if @tools.size == 1
    return 2 * @position.x + 3 * @padding + 2 * @tools[0].image.width
  end

  def display
    @caption.font = TkFont.new("family" => 'Helvetica', "size" => 15, "weight" => 'bold')
    @caption.place('x' => width / 2 - 40, 'y' => @position.y)
    current_y = @position.y + 15
    @tools.each_slice(2) do |tool_slice|
      tool_slice[0].place('x' =>  @position.x + @padding, 'y' => current_y + @padding)
      tool_slice[1].place('x' =>  @position.x + tool_slice[0].image.width + 2 * @padding, 'y' => current_y + @padding) if tool_slice[1] != nil
      current_y += tool_slice[0].image.height + @padding
    end
  end
end

root = TkRoot.new do
  title "Sokoban Level Builder"
  minsize 800, 600
  maxsize 800, 600
end

cube_tool  = Tool.new "Cube", "ToolboxNormal/cube.gif", "ToolboxClicked/cube.gif"
erase_tool = Tool.new "Erase", "ToolboxNormal/eraser.gif", "ToolboxClicked/eraser.gif"
wall_tool = Tool.new "Wall", "ToolboxNormal/wall.gif", "ToolboxClicked/wall.gif"

toolbox = ToolBox.new
toolbox.add_tool cube_tool
toolbox.add_tool erase_tool
toolbox.add_tool wall_tool

toolbox.display

some_caption = TkLabel.new { text "asd"}
some_caption.place('x' => 500, 'y' => 300)
p some_caption.text

#(cursor_image = TkPhotoImage.new).file = "ToolboxNormal/cube.gif"
#cursor_image.file = "ToolboxNormal/cube.gif"

#cursor_image1 = TkPhotoImage.new
#cursor_image1.file = "cursor.gif"
#cursor_image1.blank

#hello_label = TkLabel.new(root) do
#  text "Hello"
#  place("x" => 100, 'y' => 0.01)
#end

#word_label = TkLabel.new(root) do
#  image cursor_image
#  place("x" => 200, "y" => 250)
#end

#word_label1 = TkLabel.new(root) do
#  image cursor_image1
#  place("x" => 70, "y" => 200)
#end

#cursor_canvas = TkCanvas.new do
#  width 55
#  height 52
#end
#game_cursor = Cursor.new cursor_canvas, "grey"
#game_cursor.display(60, 20)

#cursor2_canvas = TkCanvas.new
#game_cursor2 = Cursor.new cursor2_canvas, "red"
#game_cursor2.display(50, 50)


#TkcLine.new(canvas, 0, 0, 16, 0, 'width' => '10', 'fill' => 'grey', 'smooth' => true)
#canvas.place('x' => 10, 'y' => 20)

#TkcLine.new(canvas, 0, 0, 0, 16, 'width' => '10', 'fill' => 'grey', 'smooth' => true)
#canvas.place('x' => 10, 'y' => 20)

#p root.private_methods
#p TkRoot.singleton_methods


Tk.mainloop