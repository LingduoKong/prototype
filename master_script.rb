require_relative 'trello-practice'
require_relative 'githubgem'


def yolo
  new_client("LingduoKong", "yuyang12345")
  check_messages
  generate_weekly_data("email.html", @content, 1.0)
  get_board
  get_lists
  move_cards("Deployment to staging", "Deployment to production")
  @issues_num.each do |issue_num|
    issue_num = issue_num.scan(/\d+/).first.to_i
    get_checklist_item(issue_num)
  end
  # move_cards("Completed", "Archived")
  @issues_num.each do |issue_num|
    get_checklist_item(issue_num)
  end
end

yolo

require_relative 'gmail'

