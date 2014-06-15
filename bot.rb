require 'cinch'
require 'gitlab'

# Gitlab Settings
GITLAB_ENDPOINT      = 'https://example.net/api/v3'
GITLAB_PRIVATE_TOKEN = 'gitlab user private token'

# IRC Settings
IRC_SERVER           = 'irc.freenode.org'
IRC_CHANNELS         = ['#your-channel']
IRC_NICK             = 'gitlab-cinch-bot'
IRC_SSL              = false

module GitlabBot
  class Connection
    def initialize
      Gitlab.endpoint      = GITLAB_ENDPOINT
      Gitlab.private_token = GITLAB_PRIVATE_TOKEN
    end
  end
end

module GitlabBot
  module Connector
    def initialize(bot)
      super
      GitlabBot::Connection.new
    end
  end

  class Users
    include Cinch::Plugin
    include Connector

    match /users/, method: :get_users

    def get_users(m)
      m.reply "Getting Users..."
      users = Gitlab.users.map {|u| [u.id, u.username].join(' ')}.join(' | ')
      m.reply "Projects: #{users}"
    end
  end

  class Projects
    include Cinch::Plugin
    include Connector

    match /projects/, method: :get_projects
    match /project (.+)/, method: :get_project

    def get_projects(m)
      m.reply "Getting Projects..."
      projects = Gitlab.projects.map {|p| [p.id, p.name].join(' ')}.join(' | ')
      m.reply "Projects: #{projects}"
    end

    def get_project(m, project_id)
      m.reply "Getting Project Info..."
      project = Gitlab.project(project_id)
      m.reply "#{project.name_with_namespace}: Owner: #{project.owner.name} - #{project.web_url}"
    end
  end

  class Issues
    include Cinch::Plugin
    include Connector

    match /issues (.+)/, method: :get_issues
    match /issue new (.+) '(.+)'( .+)?/, method: :create_issue
    match /issue close (.+) (.+)/, method: :close_issue
    match /issue reopen (.+) (.+)/, method: :reopen_issue

    def get_issues(m, project_id)
      m.reply "Getting Project Issues..."
      issues = Gitlab.issues(project_id)
      issues.each do |issue|
        unless issue.state == 'closed'
          m.reply "#{issue.id} | \"#{issue.title}\" -> #{issue.author.username}#{' -> ' + issue.assignee.username if issue.assignee}"
        end
      end
    end

    def create_issue(m, project_id, issue_title, assignee = nil)
      m.reply "Saving issue for project ID: #{project_id}"
      issue = Gitlab.create_issue(project_id, issue_title, { assignee_id: assignee })
      if issue.kind_of?(Gitlab::ObjectifiedHash)
        m.reply "Issue \"#{issue.title}\" created#{' and assigned to ' + issue.assignee.username if issue.assignee }!"
      end
    end

    def close_issue(m, project_id, issue_id)
      m.reply "Closing issue..."
      issue = Gitlab.close_issue(project_id, issue_id)
      if issue.kind_of?(Gitlab::ObjectifiedHash)
        m.reply "Issue \"#{issue.title}\" closed!"
      end
    end

    def reopen_issue(m, project_id, issue_id)
      m.reply "Reopening issue..."
      issue = Gitlab.reopen_issue(project_id, issue_id)
      if issue.kind_of?(Gitlab::ObjectifiedHash)
        m.reply "Issue \"#{issue.title}\" reopened!"
      end
    end
  end
end


bot = Cinch::Bot.new do
  configure do |c|
    c.server    = IRC_SERVER
    c.channels  = IRC_CHANNELS
    c.nick      = IRC_NICK
    c.ssl.use   = IRC_SSL

    c.plugins.plugins = [
      GitlabBot::Users,
      GitlabBot::Projects, 
      GitlabBot::Issues
    ]
  end
end

bot.start
