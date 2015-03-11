require 'octokit'
require 'optparse'
require 'ostruct'

# Parse command line arguments

options = OpenStruct.new
options.branches = []
options.defaultmessage = false;
options.message = ""
options.repo = ""
options.accesstoken = ""

OptionParser.new do |opts|
  opts.banner = "Usage: merge.rb [options]"
  opts.separator ""
  opts.separator "Specific options:"
  
  opts.on('-a', '--accesstoken ACCESSTOKEN', 'Your access token, e.g. \'52b3e877684d663efb032a9f5fbde244525a460d\'') { |v| options.accesstoken << v }
  opts.on('-r', '--repo REPOSITORY', 'The repository\'s name, e.g. thorbenegberts/github-api-merge-script') { |v| options.repo << v }
  opts.on('-m', '--merge FROM:TO', 'The source and destination branch (FROM:TO), e.g. mybranch:master. Can be specified multiple times.') { |v| options.branches << v }
  opts.on('-M', '--message COMMIT_MESSAGE', 'The commit message that will be uses for the merge. There are two placeholders for you can use: ":frombranch:" and ":tobranch:. Eveything has to be put in double quotes, e.g. --message "Well, I\'m merging :frombranch: to :tobranch:".') { |v| options.message << v }

end.parse!

# Login to Github

raise "Login token is missing" unless options.accesstoken.length > 0

client = Octokit::Client.new(:access_token => options.accesstoken)
user = client.user
user.login

# Repository is mandatory

raise "Repository name is missing" unless options.repo.length > 0

# Merge branches

raise "You have to specify at least one branch name" unless options.branches.count > 0

options.branches.each do |branchArgString|
    
    # Splitting branch parameter from "FROM:TO" to an array
    branchArgArray = branchArgString.split(/:/)
    
    raise "Invalid argument for source and destination branch" unless branchArgArray.count == 2
    
    branchFrom  = branchArgArray[0]
    branchTo    = branchArgArray[1]

    # Commit message
    
    commitMessage = options.message
    commitMessage = commitMessage.sub(/:frombranch:/, branchFrom)
    commitMessage = commitMessage.sub(/:tobranch:/, branchTo)
    
    # Define merge options

    mergeOptions = {}

    if
        commitMessage.length > 0
        mergeOptions[:commit_message] = commitMessage
    end

    # Merge
    
    puts "Merging branch '#{branchFrom}' to '#{branchTo}' ..."
    
		client.merge( options.repo,
      						branchTo,
      						branchFrom,
      						mergeOptions)
end