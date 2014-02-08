module Sokoban
  def self.set_toolbox_image_paths
    [["../graphics/normal_elements/wall.gif", "../graphics/toolbox_clicked/wall.gif"], ["../graphics/toolbox_normal/cube.gif", "../graphics/toolbox_clicked/cube.gif"],
    ["../graphics/toolbox_normal/final.gif", "../graphics/toolbox_clicked/final.gif"], ["../graphics/toolbox_normal/smiley.gif", "../graphics/toolbox_clicked/smiley.gif"],
    ["../graphics/toolbox_normal/eraser.gif", "../graphics/toolbox_clicked/eraser.gif"]]
  end
  
  def self.set_ground_image_paths
    ["../graphics/normal_elements/wall.gif", "../graphics/normal_elements/cube.gif", "../graphics/normal_elements/final.gif", "../graphics/normal_elements/smiley.gif", "../graphics/normal_elements/empty.gif", "../graphics/normal_elements/cube_above_final.gif", "../graphics/normal_elements/smiley_above_final.gif"]
  end

  def self.require_files
    require_relative 'position.rb'
    require_relative 'border.rb'
    require_relative 'tool.rb'
    require_relative 'toolbox.rb'
    require_relative 'ground.rb'
    require_relative 'player.rb'
    require_relative 'menu.rb'
    require_relative 'game.rb'
    require_relative 'dropdown_menu.rb'
  end
end