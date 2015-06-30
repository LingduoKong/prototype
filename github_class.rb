class Github

	def initialize(username , password)
		@client = Octokit::Client.new(:login => username, :password => password)
	end

	# get issue according to its repo and issue number
	def get_issue(repo,num)
		@issues = Octokit.issues repo,:state => "open"
		@issues.each do |issue|
			if issue.number == num
				@issue = issue
				return @issue
			end
		end
	end

	# set labels of certain issue
	def new_label (name, color, issue, repo)
		newlab = [{:name => name, :color => color}]
		@client.update_issue(repo, issue, :labels => newlab)
	end

	# get a set a commits from certain timestamp
	# t= DateTime.now - 10
  # time = t.strftime('%Y-%m-%d')
  def get_commit_messages(repo,time)
  	@commits = @client.commits_since(repo, time )
  	return @commits
  end

  # get issue numbers which are fixed
  def issume_numbers(repo,time)
  	numbers = []
  	get_commit_messages(repo,time).each do |commit|
  		if commit.commit.message=~/(.*){issue#\d+}(.*)/
  			commit = commit
  			message = commit.commit.message
      	issues_num = message.scan(/{issue#\d+}/)
      	issues_num.each do |issue_num|
      		num = issue_num.scan(/\d+/).first.to_i
      		if !numbers.include?(num)
      			numbers.insert(0,num)
      		end
      	end
      end
    end
    return numbers
  end

  # check commits to see whether there are fixed issues and business features
  def check_commit_messages(repo, time)
  	content = {}
  	content["version"] = nil
  	content["release_date"] = DateTime.now.strftime('%Y-%m-%d')
  	content["features"] = []
  	content["fix_issue"] = []

  	get_commit_messages(repo,time)
  	@commits.each do |commit|
  		if commit.commit.message=~/(.*){issue#\d+}(.*)/
  			@commit = commit
  			@message = @commit.commit.message
      	@issues_num = @message.scan(/{issue#\d+}/)
      	@issues_num.each do |issue_num|
      		num = issue_num.scan(/\d+/).first.to_i
      		new_label("fix", "00FF00", num, repo)
      		title = get_issue(repo, num).title
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

  # generate a json file for data generated weekly
  def generate_weekly_data(file_name, content, version_num = nil)
  	file = File.open(file_name, 'a+')
  	content["version"] = version_num.to_s
  	file.puts(content.to_json)
  	file.close
  end

  # generate the webpage for all release versions
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

end