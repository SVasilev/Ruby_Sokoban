module Sokoban
  def set_toolbox_image_paths
    [["ToolboxNormal/wall.gif", "ToolboxClicked/wall.gif"], ["ToolboxNormal/cube.gif", "ToolboxClicked/cube.gif"],
    ["ToolboxNormal/final.gif", "ToolboxClicked/final.gif"], ["ToolboxNormal/smiley.gif", "ToolboxClicked/smiley.gif"],
    ["ToolboxNormal/eraser.gif", "ToolboxClicked/eraser.gif"]]
  end

  def set_ground_image_paths
    ["NormalElements/wall.gif", "NormalElements/cube.gif", "NormalElements/final.gif", "NormalElements/smiley.gif", "NormalElements/empty.gif"]
  end
end