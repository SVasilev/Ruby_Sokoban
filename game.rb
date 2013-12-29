module Sokoban
  def self.game(picture_indexes = [])
    Shoes.app width: 1000, height: 600 do
      ground_image_paths = Sokoban.set_ground_image_paths
      ground_image_paths[4] = "NormalElements/nothing.gif"
      ground = Sokoban::Ground.new self, ground_image_paths

      unless picture_indexes == []        
        picture_indexes.each_index { |index| ground.picture_index_change index, picture_indexes[index][0] }
        start_image = ground.pictures[picture_indexes.index([3])]
        game_cursor = Sokoban::Player.new self, ground, "NormalElements/smiley.gif", Sokoban::Position.new(start_image.style[:left], start_image.style[:top])
        ground.picture_index_change picture_indexes.index([3]), 4
      end

      keypress do |key|
        game_cursor.move(key)
      end

    end
  end
end