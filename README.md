Github API Merge Script
=======================

A simple script that can be used to merge via the Github API.

## Preparation

The script uses the [Github API V3](https://developer.github.com/v3/) via the [Ruby flavor of Octokit](https://github.com/octokit/octokit.rb). To be more specific, the [`merge`](http://octokit.github.io/octokit.rb/Octokit/Client/Commits.html#merge-instance_method) method is used.

```
gem install octokit
```

## Usage

Execute the script via the `ruby` command:

```
ruby merge.rb [options]
```

The options are:

| Parameter         | Description                                                                                                                                                                                                                                  | Required |
|-------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------|
| --help            | Help                                                                                                                                                                                                                                         | -        |
| -a, --accesstoken | Your Github access token, see https://help.github.com/articles/creating-an-access-token-for-command-line-use/                                                                                                                                | Yes      |
| -r, --repo       | The repository name, e.g. `thorbenegberts/github-api-merge-script`                                                                                                                                                                           | Yes      |
| -m, --merge       | The source and destination branch (Pattern: FROM:TO), e.g. mybranch:master. Can be specified multiple times. The source can also be an SHA1 instead of a branch name.                                                                                                                                 | Yes      |
| -M, --message     | The commit message that will be uses for the merge. There are two placeholders for you can use: `:frombranch:` and `:tobranch:`. Eveything has to be put in double quotes, e.g. `--message "Well, I\'m merging :frombranch: to :tobranch:"`. | No       |

### Example

I want to merge the branch `my_branch` to `master` and from there to the branch `release`. I have to specify an access token for my Github account (here `52b3e877684d663efb032a9f5fbde244525a460d`, changed for this example ;-) ) and a repository name (here `thorbenegberts/github-api-merge-script`). I also specify a custom commit message:

```
ruby merge.rb --accesstoken 52b3e877684d663efb032a9f5fbde244525a460d --repo thorbenegberts/github-api-merge-script --merge my_branch:master --merge master:release --message "Merged branch ':frombranch:' to ':tobranch:'"
```
