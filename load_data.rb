module Sokoban
  def self.set_toolbox_image_paths
    [["toolbox_normal/wall.gif", "toolbox_clicked/wall.gif"], ["toolbox_normal/cube.gif", "toolbox_clicked/cube.gif"],
    ["toolbox_normal/final.gif", "toolbox_clicked/final.gif"], ["toolbox_normal/smiley.gif", "toolbox_clicked/smiley.gif"],
    ["toolbox_normal/eraser.gif", "toolbox_clicked/eraser.gif"]]
  end
  
  def self.set_ground_image_paths
    ["normal_elements/wall.gif", "normal_elements/cube.gif", "normal_elements/final.gif", "normal_elements/smiley.gif", "normal_elements/empty.gif", "normal_elements/cube_above_final.gif", "normal_elements/smiley_above_final.gif"]
  end

  def self.require_files
    require 'position.rb'
    require 'border.rb'
    require 'tool.rb'
    require 'toolbox.rb'
    require 'ground.rb'
    require 'player.rb'
    require 'menu.rb'
    require 'game.rb'
    require 'dropdown_menu.rb'
  end
end