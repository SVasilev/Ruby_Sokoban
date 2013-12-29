require 'position.rb'
require 'border.rb'
require 'tool.rb'
require 'toolbox.rb'
require 'ground.rb'
require 'player.rb'
require 'menu.rb'
require 'picture_paths.rb'
require 'game.rb'

Shoes.app width: 1000, height: 600 do

  toolbox_image_paths = Sokoban.set_toolbox_image_paths
  tool_box = Sokoban::ToolBox.new (para strong("Tool Box"), font: "Arial"), self, Sokoban::Position.new(40, 30)
  toolbox_image_paths.each { |paths| tool_box.add_tool Sokoban::Tool.new image, paths }

  ground_image_paths = Sokoban.set_ground_image_paths
  ground = Sokoban::Ground.new self, ground_image_paths
  ground.display

  saved = true
  menu = Sokoban::Menu.new self, stack, ["Test Level", "New Level", "Save Level", "Load Level"], Sokoban::Position.new(40, 382)
  menu.display
  menu.stack.contents.each do |button|
    button.click do
      case button.style[:text]
      when "Test Level"
        if ground.propriety_check == ""
          Sokoban.game ground.picture_indexes
        else
          alert ground.propriety_check
        end
      when "New Level"
        if saved == true or confirm("Are you sure you want to start new level? All data for this level will be lost.")
          ground.clear
          saved = true
        end
      when "Save Level"
        if ground.propriety_check == ""
          file = ask_save_file
          File.open(file, "w+") { |file| file.write ground.picture_indexes }
        else
          alert ground.propriety_check
        end
      when "Load Level"
        if saved == true or confirm("Are you sure you want to load new level? All data for this level will be lost.")
          file, element_to_push, file_information = ask_open_file, [], []
          File.read(file).each_char do |character| 
            if character == "]"
              file_information << element_to_push unless element_to_push == []
              element_to_push = []
            else
              element_to_push << character.to_i if character >= "0" and character < "5"
            end
          end
          p p file_information
          ground.clear
          file_information.each_index do |index|
            ground.picture_index_change index, file_information[index][0]
          end
        end
      end
    end
  end

  #game_cursor = Sokoban::Player.new self, ground, "cursor.gif"

  mouse_down = false
  click do |button, left, top| 
    if button == 1 and ground.ground_hover?(left, top)
      mouse_down = true
      saved = false
    end
  end
  release do |button, left, top|
    if button == 1 and ground.ground_hover?(left, top)
      ground.update left, top, tool_box
      mouse_down = false
    end
  end
  motion { |left, top| ground.update left, top, tool_box if mouse_down }

  keypress do |key|
    if key == " "
      ground.fix_start if tool_box.clicked_tool == 3
      ground.picture_indexes[game_cursor.index] = tool_box.clicked_tool
      ground.display
    else
      game_cursor.move(key)
    end
  end

  tool_box.display
  tool_box.tools.each_index do |index|
    tool_box.tools[index].picture.click do
      tool_box.clicked_tool = index
      tool_box.display
    end
  end

  dummy = [[4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [0], [0], [0], [0], [0], [0], [4], [4], [4], [4], [4], [4], [4], [4], [0], [4], [4], [4], [4], [0], [4], [4], [4], [4], [4], [4], [4], [4], [0], [3], [4], [1], [2], [0], [4], [4], [4], [4], [4], [4], [4], [4], [0], [0], [0], [0], [0], [0], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4]]
  dummy.each_index do |index|
    ground.picture_index_change index, dummy[index][0]
  end
  #@button = button "asd"
  #@button.style width: 100
  #p @button.style[:width]
end