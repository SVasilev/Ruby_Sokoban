class Position
  attr_accessor :x, :y

  def initialize(x = 0, y = 0)
    @x = x
    @y = y
  end
end

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

class Tool
  attr_accessor :picture, :load_paths

  def initialize(picture, paths)
    @picture = picture
    @load_paths = paths
  end
end

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

class Ground
  attr_reader :width, :height, :position
  def initialize(window, picture_paths = [], width = 14, height = 10, position = Position.new(220, 30))
    @window = window
    @pictures = []
    @picture_indexes = []
    (width * height).times do 
      @pictures << (window.image picture_paths[4])
      @picture_indexes << 4
    end
    @picture_indexes[0] = 0
    @picture_indexes[1] = 1
    @picture_indexes[2] = 2
    @picture_indexes[3] = 3

    @picture_paths = picture_paths
    @width = width
    @height = height
    @position = position
  end

  def width_in_pxels
    @width * @pictures[0].full_width
  end

  def height_in_pixels
    @height * @pictures[0].full_height
  end

  def draw_border
    Border.new(@window, Position.new(@position.x, @position.y), Position.new(@position.x + width_in_pxels, @position.y + height_in_pixels), 15).draw
  end

  def display
    current_x, current_y = @position.x, @position.y
    @pictures.each_index do |index|
      @pictures[index].path = @picture_paths[@picture_indexes[index]]
      @pictures[index].move current_x, current_y
      current_x += @pictures[index].full_width
      if ((index + 1).remainder @width) == 0
        current_x  = @position.x
        current_y += @pictures[index].full_height
      end
    end
    draw_border
  end
end

class Cursor
  def initialize(window, ground, picture_path = "")
    @window   = window
    @ground   = ground
    @index    = 0
    @position = Position.new ground.position.x, ground.position.y
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

    p @index
  end
end

#this kinda functions should go in some module? or in other file which will be included/required?
def set_toolbox_image_paths
  [["ToolboxNormal/wall.gif", "ToolboxClicked/wall.gif"], ["ToolboxNormal/cube.gif", "ToolboxClicked/cube.gif"],
  ["ToolboxNormal/final.gif", "ToolboxClicked/final.gif"], ["ToolboxNormal/smiley.gif", "ToolboxClicked/smiley.gif"],
  ["ToolboxNormal/eraser.gif", "ToolboxClicked/eraser.gif"]]
end

def set_ground_image_paths
  ["NormalElements/wall.gif", "NormalElements/cube.gif", "NormalElements/final.gif", "NormalElements/smiley.gif", "NormalElements/empty.gif"]
end

Shoes.app width: 1000, height: 600 do
  toolbox_image_paths = set_toolbox_image_paths
  tool_box = ToolBox.new (para strong("Tool Box"), font: "Arial"), self, Position.new(40, 30)
  toolbox_image_paths.each { |paths| tool_box.add_tool Tool.new image, paths }

  ground_image_paths = set_ground_image_paths
  ground = Ground.new self, ground_image_paths
  ground.display

  game_cursor = Cursor.new self, ground, "cursor.gif"
  keypress do |key|
    game_cursor.move(key)
  end

  tool_box.display
  tool_box.tools.each_index do |index|
    tool_box.tools[index].picture.click do
      tool_box.clicked_tool = index
      tool_box.display
    end
  end
end