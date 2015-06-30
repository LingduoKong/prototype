class Cus_Trello

	def initialize(public_key,member_token)
		Trello.configure do |trello|
			trello.developer_public_key = public_key
			trello.member_token = member_token
		end
	end

# test: 558b0e12f2e6f4aa751abe4d
# dev: 552454f0fc2cbc53c307b025

	def get_board
		@board = Trello::Board.find("558b0e12f2e6f4aa751abe4d")
		return @board
	end

	def get_lists
		@lists = @board.lists
		return @lists
	end

	def get_list(list_name)
		@lists.each do |list|
			if list.name[list_name]
				@list = list
				return @list
			end
		end
		return nil
	end

	def get_cards(list)
		return @cards= list.cards
	end

	# check the checkitem if it is finished
	def get_checklist_item(issue_number)
		flag = false
		@cards.each do |card|
			card.checklists.each do |checklist|
				checklist.items.each do |item|
					if item.name["/issues/" + issue_number.to_s + ")"]
						change_item_state(checklist, item)
						flag = true
					end
				end
			end
		end
		return flag
	end

# check the box of a certain item
def change_item_state(checklist, item)
	id = item.id
	pos = item.pos
  # checked = item.state_was == "complete" ? true : false
  name = item.name
  checklist.delete_checklist_item(id)
  checklist.add_item(name, true, pos)
  checklist.save
end

# move cards from one list to another if it is finished
def move_cards(list_from_name, list_to_name)
	from_list = get_list(list_from_name)
	to_list = get_list(list_to_name)

  # if from_list == nil || to_list == nil
  #   p "nil list error, check list names"
  #   return 
  # end
  cards = get_cards(from_list)
  cards.each do |card|
  	if card.badges["checkItems"] == card.badges["checkItemsChecked"]
  		card.move_to_list(to_list)
  	end
  end
end

end