# gitlab-cinch-bot

Manage your GitLab installation via IRC.

## Usage

#### Users
* View Users `!users`

#### Projects
* View Projects `!projects`
* View Project `!project ID`

#### Issues
* View Issues for Project `!issues PROJECT_ID`
* Create Issues for Project `!issue new PROJECT_ID 'Issue Title'`
* Create Issues for Project and add an Assignee `!issue new PROJECT_ID 'Issue Title' ASSIGNEE_ID`
* Close Issue for Project `!issue close PROJECT_ID ISSUE_ID`
* Reopen Issue for Project `!issue reopen PROJECT_ID ISSUE_ID`

## Install

- Clone this repository or save the *bot.rb* file.
- Edit bot.rb
- Install cinch and gitlab gems: ```gem install cinch``` and ```gem install gitlab```
- Run bot.rb ```ruby bot.rb```

## Tools

This bot utilizes two ruby gems:

* [cinch](https://github.com/cinchrb/cinch) - IRC Bot Framework written in Ruby.
* [gitlab](https://github.com/NARKOZ/gitlab) - GitLab API wrapper for Ruby.

## Development

Notice: Soon i will transform this 'script' in a real gem, so everyone can install it via rubygems.org.

But until then, feel free to fork this project and add functionalities, i'm more than happy to merge more features!

* [GitLab API Docs](http://doc.gitlab.com/ce/api/) - More informations about GitLabs API Interface.
