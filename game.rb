module Sokoban
  def self.game(level = "")
    Shoes.app width: 1000, height: 600 do
      ground_image_paths = Sokoban.set_ground_image_paths
      ground = Sokoban::Ground.new self, ground_image_paths
      ground.display
    end
  end
end