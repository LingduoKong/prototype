require 'octokit'
require 'json'
require 'trello'
require_relative 'github_class'
require_relative 'trello_class'

@github = Github.new("LingduoKong","yuyang12345")

content = @github.check_commit_messages("LingduoKong/final","2015-06-20")

@github.generate_weekly_data("json",content,"2.0.1")

@github.generate_webpage("json")

TRELLO_DEVELOPER_PUBLIC_KEY="7e9522e062d8095332b4a1abea9d5c2d"
TRELLO_MEMBER_TOKEN="2ee3ba64087c31a8f85af0aa482315bc1025091086517f1bdd9eea1038cfe0fc"

@trello = Cus_Trello.new(TRELLO_DEVELOPER_PUBLIC_KEY,TRELLO_MEMBER_TOKEN)

@trello.get_board

@trello.get_lists

list = @trello.get_list("Deployment to staging")

@trello.get_cards(list)
issume_numbers.each do |issue_num|
  @trello.get_checklist_item(issue_num)
end

@trello.move_cards("Deployment to staging", "Deployment to production")
