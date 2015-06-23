
require 'trello'

TRELLO_DEVELOPER_PUBLIC_KEY="7e9522e062d8095332b4a1abea9d5c2d"

TRELLO_MEMBER_TOKEN="member_token"

Trello.configure do |trello|
  trello.developer_public_key = TRELLO_DEVELOPER_PUBLIC_KEY
  trello.member_token = TRELLO_MEMBER_TOKEN
end

Trello::Board.all.each do |board|
  puts "* #{board.name}"
end

@board = Trello::Board.all.first

implement_list = @board.lists[5]

hock_card = implement_list.cards[4]

checklist = hock_card.checklists[0]

attributes = checklist.attributes

check_items = attributes[:check_items]

puts check_items