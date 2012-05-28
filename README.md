# GitStory

This gem is a helper for checking which commits in your git repository belonges to unaccepted PivotalTracker's story so that you can make a decision whether you should deploy those commits or not.

[![Build Status](https://secure.travis-ci.org/visibletrap/git_story.png)](http://travis-ci.org/visibletrap/git_story)

## Installation

Add this line to your application's Gemfile:

    gem 'git_story'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install git_story
    
Then you need to set PivotalTraker's api token to your environment variable:

	export TRACKER_TOKEN=your_pivotal_tracker_api_token
	
Or set permanently by append it to .profile or .bashrc or .bash_profile.

## Specific projects

By default, git-story will check from all of your PivotalTracker projects, but you can also set a specific list of projects. To do so, just add another environment variable like following:

	export TRACKER_PROJECT_ID=your_pivotal_tracker_project_id

If you need to set multiple projects, add them using comma separated format.

## Requirements

This gem required you to put **[#tracker_story_id]** in the begining of commit messages to specify relationships between commit and story.

## Usage

	$ git story <after_commit> <until_commit>
	
**\<commit>** can be **sha-1** or **branch name** or **tag**
	
## Example

	$ git story e1a4be4 9a5bfa42
	9a5bfa42712ba2a5cc76b504966d05bfd848892c #29606203 delivered
	9f40f97dfa2200c4fdd94aa38d03d52d9123bb69 #29973257 delivered
	ac7f751c58d16453b2c4b4c9005cd5f8936cdd18 #29306719 finished
	0030d2bd62b41092bfb81f9b20b6f00c83a99bf5 #29537523 delivered
	fcb41b56a5bcf9e66ce9f83d6b4583d7b1ab01bd #30061821 rejected
	b8500d607ead27c3c277e2ac03f18ccaaeb645b0 #30128209 delivered
or
	
	$ git story origin/production staging_tag

	
## Notice

 - Current implementation is ignoring **unknown stories** and **non-story_id prefixed commit**.
 - If many commits are belonging to a story, only one commit will be displayed.

## Contributors

 - [acroca](https://github.com/acroca)
