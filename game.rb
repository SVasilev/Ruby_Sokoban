module Sokoban
  def self.game(picture_indexes = [])
    Shoes.app title: "Sokoban", width: 1000, height: 600, resizable: false do
      ground_image_paths = Sokoban.set_ground_image_paths
      ground_image_paths[4] = "NormalElements/nothing.gif"
      ground = Sokoban::Ground.new self, ground_image_paths, Sokoban::Position.new(150, 50)

      if picture_indexes == []

      else
        picture_indexes.each_index do |index|
          picture_indexes[index].each do |element|
            ground.picture_index_change index, element
          end
        end
        if picture_indexes.include?([2, 3])
          start_image = ground.pictures[picture_indexes.index([2, 3])]
          ground.pictures[picture_indexes.index([2, 3])].path = ground.picture_paths[2]
          picture_indexes[picture_indexes.index([2, 3])] = [2]
        else
          start_image = ground.pictures[picture_indexes.index([3])]
          ground.picture_index_change picture_indexes.index([3]), 4
        end
        player_cursor = Sokoban::Player.new self, ground, "NormalElements/smiley.gif", Sokoban::Position.new(start_image.style[:left], start_image.style[:top])
        menu_bar = Sokoban::DropdownMenu.new self, "Game", ["Restart", "Exit"]
      end

      menu_bar.menu.contents.each_index do |index|
        unless index == 0
          menu_bar.menu.contents[index].click do
            close if menu_bar.menu.contents[index].contents[0].text.include? "Exit"
            if menu_bar.menu.contents[index].contents[0].text.include? "Restart"
              close
              Sokoban.game picture_indexes
            end
            menu_bar.toggle_menu
          end
        end
      end

      keypress do |key| 
        player_cursor.move(key)
        alert "Level solved!" if ground.picture_indexes.all? { |element| element != [1] }
      end
    end
  end
end