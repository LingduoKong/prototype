# require 'trello'

# Trello.configure do |config|
#   # API key generated by visiting https://trello.com/1/appKey/generate
#   config.developer_public_key = '7e9522e062d8095332b4a1abea9d5c2d'

#   # Member token
#   # larry-price.com/blog/2014/03/18/connecting-to-the-trello-api/
#   config.member_token = '61a0f93b284263b4439a0ee064a82bc09bc6df125978a34891792026cb3b90e7'
# end
# 2ee3ba64087c31a8f85af0aa482315bc1025091086517f1bdd9eea1038cfe0fc
require 'trello'

TRELLO_DEVELOPER_PUBLIC_KEY="7e9522e062d8095332b4a1abea9d5c2d"

TRELLO_MEMBER_TOKEN=

Trello.configure do |trello|
  trello.developer_public_key = TRELLO_DEVELOPER_PUBLIC_KEY
  trello.member_token = TRELLO_MEMBER_TOKEN
end

def get_board
  @board = Trello::Board.find("552454f0fc2cbc53c307b025")
  @board
end

def get_lists
  @lists = @board.lists
end

def get_list(list_name)
  @lists.each do |list|
    if list.name == list_name
      @list = list
      @list
    end
  end
end

def get_cards(list)
  @cards= list.cards
end

def get_checklist_item(issue_number)
  @cards.each do |card|
    card.checklists.each do |checklist|
      checklist.items.each do |item|
        if item.name[issue_number]
          change_item_state(checklist, item)
        end
      end
    end
  end
end

#checklist = card checklist
#item = matching checklist item
def change_item_state(checklist, item)
  id = item.id
  pos = item.pos
  checked = item.state_was == "complete" ? true : false
  name = item.name
  checklist.delete_checklist_item(id)
  checklist.add_item(name, !checked, pos)
  checklist.save
end

get_board
get_lists
get_list("Implementation")
get_cards(@list)
get_checklist_item('test item')





# def get_list()
  
# end

# def check_off_issue
  
# end
# puts "Lists: #{board.lists.map {|x| x.name}.join(', ')}"
# puts "Members: #{board.members.map {|x| x.full_name}.join(', ')}"
# board.cards.each do |card|
#       puts "- \"#{card.name}\""
#       puts "-- Actions: #{card.actions.nil? ? 0 : card.actions.count}"
#       puts "-- Members: #{card.members.count}"
#       puts "-- Labels: #{card.labels.count}"
# end













