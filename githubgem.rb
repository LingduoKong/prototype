require 'octokit'
require 'json'

# create a client instance to log in the github account
def new_client(username , password)
  @client = Octokit::Client.new(:login => username, :password => password)
end

# assistance function to get a issue by issue number
def get_issue(num)
  @issues = Octokit.issues "LingduoKong/final",:state => "open"
  @issues.each do |issue|
    if issue.number == num
      @issue = issue
      return @issue
    end
  end
end

# set labels of certain issue
def new_label (name, color, issue)
  newlab = [{:name => name, :color => color}]
  @client.update_issue("LingduoKong/final", issue, :labels => newlab)
end

# get commit messages from a time
# currently it is a hard code timestamp
# it should have a parameter of timestamp and track from that
def commit_messages
  t= DateTime.now - 10
  time = t.strftime('%Y-%m-%d') 
  @commits = @client.commits_since("LingduoKong/final", time )
  return @commits
 end

# it returns issue numbers appearing in the commit messages 
# format is like {issue#123}, meaning that issue 123 has been fixed
def issume_numbers
  numbers = []
  commit_messages.each do |commit|
    if commit.commit.message=~/(.*){issue#\d+}(.*)/
      @commit = commit
      @message = @commit.commit.message
      @issues_num = @message.scan(/{issue#\d+}/)
      @issues_num.each do |issue_num|
        num = issue_num.scan(/\d+/).first.to_i
        if !numbers.include?(num)
          numbers.insert(0,num)
        end
      end
    end
  end
  return numbers
end

def check_commit_messages
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
        title = get_issue(num).title
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
      end
    end
  end
  @content = content
  return @content
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

def generate_weekly_data(file_name, content, version_num = nil)
  file = File.open(file_name, 'a+')
  content["version"] = version_num.to_s
  file.puts(content.to_json)
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
  text.gsub!(/\r\n?/, "")

  page = File.open("version.html","w")

  page.puts('<body style="padding-right:10%;padding-left:10%;margin-right:auto;margin-left:auto">')

  text.each_line do |line|
    hs = JSON.parse(line)
    if ! hs["version"].empty?
      page.puts "<h2>" + "version" + hs["version"] + "</h2>"
      page.puts '<span style="font-size: 10pt">Release Date:' + hs["release_date"] + "</span>"
      page.puts '<hr>'
    else
      page.puts '<span style="font-size: 10pt">Date:' + hs["release_date"] + "</span>"
    end
    page.puts "<h3>features</h3>"
    page.puts '<ul>'
    hs["features"].each do |feature|
      page.puts '<li>' + feature.to_s + '</li>'
    end
    page.puts '</ul>'

    page.puts "<h3>issues</h3>"
    page.puts '<ul>'
    hs["fix_issue"].each do |issue|
      page.puts '<li>' + issue.to_s + '</li>'
    end
    page.puts '</ul>'
  end

  page.puts('</body>')

  page.close

end

new_client("LingduoKong", "yuyang12345")

check_commit_messages
