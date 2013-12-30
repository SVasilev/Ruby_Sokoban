# Krzysztof B. Wicher 2008 version v0.6
# 
# Menu = Widget emulating pop-up menu with a given ":title" and ":width" and
# at the given coordinates (":left", ":top") in the current slot.
# One can choose if the menu will pop-up upon hoovering on -
# :pop_up_on_click=>false or upon clicking on the title - :pop_up_on_click=>true
# One can choose to leave menu open upon moving mouse out - :pop_out_on_leave=>false 
# or to hide it - :pop_out_on_leave=>false
# Menu items are loaded from the ":items" array. One can also specify the items in the menu
# which should be inactive/unresposive to the hoovering and clicking ":blocked" array.
# Moreover, one can dinamically change the ":items" and ":blocked" using attr_accessors. 
# Method returns the "item" clicked.
# ":state" attr-accessor allows to disable (:disabled) and enable (:enable) the menu
# State can be toggled by using "toggle_state" method.
# For simplicity method hard-codes menu colors

class Menu < Shoes::Widget
  attr_accessor :items, :blocked, :state
  def set_blocked(blocked)
    @blocked=blocked
  end
  def toggle_state
    case @state
    when :enabled then @state=:disabled
    when :disabled then @state=:enabled
    end
  end
  def initialize opts={}
    @state=:enabled
    @title=opts[:title]
    @items=opts[:items]
    @blocked=opts[:blocked]
    @leavee=opts[:pop_out_on_leave]
    @width=opts[:width]
    hor_mult=0
    vert_mult=0
    showed=false
    clicke=opts[:pop_up_on_click]
    case opts[:orientation]
    when :ver then vert_mult=25
    when :hor then hor_mult=@width
    end
    nostroke
    fill yellow
    m=[]
    flot = flow :top=>0, :left=>0, :width=>@width-1, :height=>24 do
      background yellow
      para @title, :align=>'center'
      leave do
        flot.clear do
          background yellow
          para @title, :align=>'center'
        end
      end 
    end
    fl=stack :left=>0, :top=>0, :width=>(hor_mult+1)*@items.size+@width, :height=>(vert_mult+1)*@items.size+25 do      
      leave do    
        if showed
          if @leavee==true
            m.each_index do|l| 
              m[l].clear
              m[l].remove
            end
            showed=false
          end
        end
      end
  # IF POP-UP BY CLICKING
      if clicke==true 
        flot.click do
          if @state==:enabled
            flot.hover do
              flot.clear do
                background orange
                para @title, :align=>'center'
              end
            end
            if showed==false
              showed=true
              @items.each_with_index do |i,l|
                m[l]=stack :top=>vert_mult*(l+1),:left=>hor_mult*(l+1),:width=>@width-1,:height=>24 do 
                  if not @blocked.include?(i)
                    background red
                    para @items[l]
                  else
                    background gray
                    para @items[l]
                  end
                end      
                m[l].hover do
                  if not @blocked.include?(i)
                    m[l].clear do
                      background green
                      para @items[l]
                    end
                  end
                end
                m[l].leave do
                  if not @blocked.include?(i)
                    m[l].clear do
                      background red
                      para @items[l]
                    end
                  end
                end
                m[l].click do
                  if not @blocked.include?(i)
                    showed=false
                    res=i
                    m.each{|i| i.remove}   
                    yield res
                  end
                end
              end
            else 
              m.each{|i| i.remove}
              showed=false
            end
          end
        end
   #IF POP-UP BY HOVER
      elsif clicke==false 
        
        flot.hover do
          if @state==:enabled
            flot.clear do
              background orange
              para @title, :align=>'center'
            end
            showed=true
            @items.each_with_index do |i,l|
              m[l]=stack :top=>(vert_mult*(l+1)),:left=>hor_mult*(l+1),:width=>@width-1,:height=>24 do 
                if not @blocked.include?(i)
                  background red
                  para @items[l]
                else
                  background gray
                  para @items[l]
                end
              end      
              m[l].hover do
                if not @blocked.include? i
                  m[l].clear do
                    background green
                    para @items[l]
                  end
                end
              end
              m[l].leave do
                if not @blocked.include?(i)
                  m[l].clear do
                    background red
                    para @items[l]
                  end
                end
              end
              m[l].click do
                if not @blocked.include?(i)
                  res=i 
                  m.each{|i|
                    i.clear
                    i.remove}
                  showed=false
                  yield res
                end
              end
              m[l].show
            end
          end
        end
      end
    end
  end   
end

# TEST APPLICATION

Shoes.app :width=>450, :height=>350 do  
  stack do
    subtitle "Menu test"
    @t=edit_line "Click the menu"
    items=["item1","item2", "item3"]
    items1=["it1","it2", "it3", "it4"]
    m1=menu(:title=>"Menu1",:left=>80, :top=>100, :width=>70, :items=>items,:blocked=>["item2"], :orientation=>:ver, :pop_up_on_click=>true, :pop_out_on_leave=>false){|x| @t.text=x}    
    m2=menu(:title=>"Menu2",:left=>10, :top=>130, :width=>70, :items=>items1, :blocked=>["it3"], :orientation=>:hor, :pop_up_on_click=>false, :pop_out_on_leave=>true){|x| alert "You clicked: #{x}"}
    button "Close", :top=>180, :left=> 200 do
      close 
    end
    button "Change Menu2 items", :top=>220, :left=> 200 do
      m2.items=["it3", "it4"]
    end
    button "Change back Menu2 items", :top=>260, :left=> 200 do
      m2.items=["it1","it2", "it3", "it4"]
    end
    button "Toggle enable/disable Menu2", :top=>300, :left=> 200 do
      m2.toggle_state
    end
  end
end


__END__
require 'position.rb'
require 'border.rb'
require 'tool.rb'
require 'toolbox.rb'
require 'ground.rb'
require 'player.rb'
require 'menu.rb'
require 'picture_paths.rb'
require 'game.rb'

Shoes.app title: "Sokoban editor", width: 1000, height: 600, resizable: false do

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
          ground.clear
          file_information.each_index do |index|
            file_information[index].each do |element|
              ground.picture_index_change index, element
            end
          end
        end
      end
    end
  end

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

  tool_box.display
  tool_box.tools.each_index do |index|
    tool_box.tools[index].picture.click do
      tool_box.clicked_tool = index
      tool_box.display
    end
  end

  #dummy = [[4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [0], [0], [0], [0], [0], [0], [4], [4], [4], [4], [4], [4], [4], [4], [0], [3], [4], [4], [4], [0], [4], [4], [4], [4], [4], [4], [4], [4], [0], [4], [4], [2, 1], [4], [0], [4], [4], [4], [4], [4], [4], [4], [4], [0], [4], [1], [2], [4], [0], [4], [4], [4], [4], [4], [4], [4], [4], [0], [0], [0], [0], [0], [0], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4], [4]]
  #dummy.each_index do |index|
  #  dummy[index].each do |element|
  #    ground.picture_index_change index, element
  #  end
  #end
  #Sokoban.game ground.picture_indexes
  
  #@button = button "asd"
  #@button.style width: 100
  #p @button.style[:width]
end