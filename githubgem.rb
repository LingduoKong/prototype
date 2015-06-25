require 'octokit'
# client = Octokit::Client.new(:login => 'alcastaneda', :password => 'milkshake723')

# issues = Octokit.issues 'rails/rails', :per_page => 100

# p issue = issues[0]

# issue.number

def new_client(username , password)
  @client = Octokit::Client.new(:login => username, :password => password)
  # p user = client.user
  # p user.login
  # p user.repos
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

def compare 
  commit_messages
  @commits.each do |commit|
    if commit.commit.message=~/(.*){issue#\d*}(.*)/
      @commit = commit
      @message = @commit.commit.message
      @issues_num = @message.scan(/{issue#\d+}/)
      @issues_num.each do |issue_num|
        num = issue_num.scan(/\d+/).first.to_i
        new_label("fix", "00FF00", num)
      end
    end
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
new_client()
commit_messages
@commits
compare