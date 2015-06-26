require 'octokit'
require 'json'

# issues = Octokit.issues 'rails/rails', :per_page => 100

# p issue = issues[0]

# issue.number

def new_client(username , password)
  @client = Octokit::Client.new(:login => username, :password => password)
  # p user = client.user
  # p user.login
  # p user.repos
end

def get_issues(num)
  @issues = Octokit.issues "LingduoKong/final", :per_page => 100, :state => "open"
  @issues.each do |issue|
    if issue.number == num
      @issue = issue
      return @issue
    end
  end
end

def new_label (name, color, issue)
  newlab = [{:name => name, :color => color}]
  @client.update_issue("LingduoKong/final", issue, :labels => newlab)
end

def commit_messages
  # puts @commits[5].commit.methods
  # p @client.methods
  # p @client.commits_since(@commits.each{|commit| commit.commit.date})
  # p @client.commits_since(DateTime.now.to_date)
  t= DateTime.now - 30
  time = t.strftime('%Y-%m-%d') 

  @commits = @client.commits_since("LingduoKong/final", time )
   # DateTime.now.to_s
 end

#  def compare_issue_numbers(issue_num) 
#   commit_messages
#   @commits.each do |commit|
#     if commit.commit.message[issue_num]
#       @commit = commit
#       p @message = @commit.commit.message
#     end
#   end
# end

def check_messages
  content = {}
  content["version"] = nil
  content["release_date"] = DateTime.now.strftime('%Y-%m-%d')
  content["features"] = []
  content["fix_issue"] = []

  commit_messages
  @commits.each do |commit|
    if commit.commit.message=~/(.*){issue#\d+}(.*)/
      @commit = commit
      @message = @commit.commit.message
      @issues_num = @message.scan(/{issue#\d+}/)
      @issues_num.each do |issue_num|
        num = issue_num.scan(/\d+/).first.to_i
        new_label("fix", "00FF00", num)
        title = get_issues(num).title
        if !content["fix_issue"].include?(title)
          content["fix_issue"].insert(0, title)
        end
      end
    end

    if commit.commit.message=~/(.*){feature#.+}(.*)/
      @commit = commit
      @message = @commit.commit.message
      @features = @message.scan(/{feature#.+}/)
      @features.each do |feature|
        feature = feature.split("#")[1].split("}").first
        if !content["features"].include?(feature)
          content["features"].insert(0, feature)
        end
        puts feature
      end
    end
  end
  return content
end

# “version” : Version 2.0.2
# "release_date" : Release Date: 8 July 2013
# "features" : 
# [
# Sublime Text 3 beta is now available from http://www.sublimetext.com/3,
# Removed expiry date,
# Backported various fixes from Sublime Text 3,
# Improved minimap click behavior. The old behavior is available via the minimap_scroll_to_clicked_text setting,
# Added copy_with_empty_selection setting, to control the behavior of the copy and cut commands when no text is selected
# ]
# "fix_issues" :
# [
# ]

def generate_weekly_data(file_name, content, version_num)
  file = File.open(file_name, 'a+')
  content["version"] = version_num
  file.write(content.to_json)
  file.close
end

# <h2>Version 2.0.2</h2>
# <span style="font-size: 10pt">Release Date: 8 July 2013</span>
# <ul>
#     <li>Sublime Text 3 beta is now available from <a href="http://www.sublimetext.com/3">http://www.sublimetext.com/3</a></li>
#     <li>Removed expiry date</li>
#     <li>Backported various fixes from Sublime Text 3</li>
#     <li>Improved minimap click behavior. The old behavior is available via the <tt>minimap_scroll_to_clicked_text</tt> setting</li>
#     <li>Added <tt>copy_with_empty_selection</tt> setting, to control the behavior of the copy and cut commands when no text is selected</li>
# </ul>

def generate_webpage(file_name)
  text=File.open(file_name).read
  text.gsub!(/\r\n?/, "\n")
  text.each_line do |line|
    return line
  end
end
# def commit_comments
#   p @commit.ea
# end

# compare("new one")
# def get_repos(username)
#   user = Octokit.user username
#   user.rels[:repos].href
#   repos = user.rels[:repos].get.data
#   puts repos.last.commits_url
#   user.methods
# end

# def get_issues
#   issues = Octokit.issues 'rails/rails', :per_page => 100, :state => "open"
#    p issues[0]
# end

# def change_status
#   get_issues

#   issues.each do |issue|
#     issue.state = "closed"
#     p issue.state
#   end
# end

# def change_label
#   get_issues

#   issues.each do |issue|
#     issue.labels = [{url: 'whatever', name: 'i hope this works', color: '00FF00'}]
#     p issue.labels
#   end
# end
# new_label("test","33CC33")
new_client("LingduoKong", "yuyang12345")

check_messages