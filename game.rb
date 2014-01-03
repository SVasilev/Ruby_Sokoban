module Sokoban
  def self.game(picture_indexes = [])
    Shoes.app title: "Sokoban", width: 1000, height: 600, resizable: false do
      ground_image_paths = Sokoban.set_ground_image_paths
      ground_image_paths[4] = "NormalElements/nothing.gif"
      ground = Sokoban::Ground.new self, ground_image_paths, Sokoban::Position.new(150, 50)

      if picture_indexes == []
        menu_bar = Sokoban::DropdownMenu.new self, "Game", ["Load", "Restart", "Exit"]
      else
        Sokoban.reset_ground picture_indexes, ground
        player_cursor = Sokoban.create_curosor self, picture_indexes, ground
        menu_bar = Sokoban::DropdownMenu.new self, "Game", ["Restart", "Exit"]
      end

      menu_bar.menu.contents.each_index do |index|
        unless index == 0
          menu_bar.menu.contents[index].click do
            if menu_bar.menu.contents[index].contents[0].text.include? "Load"
              file, element_to_push, file_information = ask_open_file, [], []
              File.read(file).each_char do |character| 
                if character == "]"
                  file_information << element_to_push unless element_to_push == []
                  element_to_push = []
                else
                  element_to_push << character.to_i if character >= "0" and character < "5"
                end
              end
              picture_indexes = file_information
              Sokoban.reset_ground file_information, ground
              player_cursor = Sokoban.create_curosor self, file_information, ground
            end

            if menu_bar.menu.contents[index].contents[0].text.include? "Restart" and picture_indexes != []
              Sokoban.reset_ground picture_indexes, ground
              player_cursor.clear
              player_cursor = Sokoban.create_curosor self, picture_indexes, ground
            end

            close if menu_bar.menu.contents[index].contents[0].text.include? "Exit"
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

  def self.create_curosor(window, picture_indexes, ground)
    if picture_indexes.include?([2, 3])
      start_image = ground.pictures[picture_indexes.index([2, 3])]
      ground.pictures[picture_indexes.index([2, 3])].path = ground.picture_paths[2]
      ground.picture_indexes[picture_indexes.index([2, 3])] = [2]
    else
      start_image = ground.pictures[picture_indexes.index([3])]
      ground.picture_index_change picture_indexes.index([3]), 4
    end
    Sokoban::Player.new window, ground, "NormalElements/smiley.gif", Sokoban::Position.new(start_image.style[:left], start_image.style[:top])

  end

  def self.reset_ground(picture_indexes, ground)
    ground.clear
    picture_indexes.each_index do |index|
      picture_indexes[index].each do |element|
        ground.picture_index_change index, element
      end
    end
  end
end