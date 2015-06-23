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

def new_label (name, color)
  new_client("")
  newlab = [{:name => name, :color => color}]
  p @client.update_issue("LingduoKong/final", 1, :labels => newlab)
end

def commit_messages
  new_client("")
  newlabel = [{:name => name, :color => color}]
  p @client.update_issue("LingduoKong/final", 1, :labels => newlabel)
end

def commit_messages
  @commits= @client.commits("LingduoKong/final")
  # puts @commits[5].commit.methods
  # p @client.methods
  # p @client.commits_since(@commits.each{|commit| commit.commit.date})
   # p @client.commits_since(DateTime.now.to_date)
   puts DateTime.now
   @client.commits_since("LingduoKong/final", "2011-01-20")
   # DateTime.now.to_s
end

def compare(issue_num) 
  commit_messages
  @commits.each do |commit|
    if commit.commit.message == issue_num
        p commit.commit.message
    else
      p "not working"
    end
  end
end

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
commit_messages
