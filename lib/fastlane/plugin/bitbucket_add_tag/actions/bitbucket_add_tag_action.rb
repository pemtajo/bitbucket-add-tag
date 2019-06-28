require 'fastlane/action'
require_relative '../helper/bitbucket_add_tag_helper'

module Fastlane
  module Actions
    class BitbucketAddTagAction < Action
      def self.run(params)
        base_url = "https://api.bitbucket.org/2.0/repositories/#{params[:project_team_name]}/#{params[:rep_name]}/refs/tags" 
        body = {
                 name: params[:tag_name],
                 target: {
                   hash: params[:commit_hash]
                 }          
               }
        header = {"Content-Type": "application/json", "Authorization": params[:auth_token]}

        uri = URI.parse(base_url)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = (uri.scheme == "https")
        request = Net::HTTP::Post.new(uri.path, header)
        request.body = JSON.generate(body)
        response = http.request(request)
          
        if response.kind_of?(Net::HTTPSuccess)
            UI.success("Tag #{params[:tag_name]} successfully created.")
        else
            UI.error("HTTP request to '#{uri}' with message '#{body}' failed with a #{response.code} response.")
            UI.user_error!('Error creating tag using Bitbucket rest Api. Please verify the bitbucket rest api doc.')
        end
      end

      def self.description
        "Creates tag according to the given name"
      end

      def self.authors
        ["paulo.albuquerque"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        # Optional:
        "This plugin creates tag on bitbucket using atlassian rest api"
      end

      def self.available_options
        [
           FastlaneCore::ConfigItem.new(key: :project_team_name,
                                   env_name: "BITBUCKET_ADD_TAG_PROJECT_NAME",
                                description: "Bitbucket project name",
                                   optional: false,
                                       type: String),

           FastlaneCore::ConfigItem.new(key: :rep_name,
                                   env_name: "BITBUCKET_ADD_TAG_REPOSITORY_NAME",
                                description: "Bitbucket repository name",
                                   optional: false,
                                       type: String),

           FastlaneCore::ConfigItem.new(key: :auth_token,
                                   env_name: "BITBUCKET_ADD_TAG_AUTH_TOKEN",
                                description: "Auth Basic token. See bitbucket auth doc: https://developer.atlassian.com/server/bitbucket/how-tos/example-basic-authentication/",
                                   optional: false,
                                       type: String),

           FastlaneCore::ConfigItem.new(key: :tag_name,
                                   env_name: "BITBUCKET_ADD_TAG_TAG_NAME",
                                description: "Tag name to be created",
                                   optional: false,
                                       type: String),

           FastlaneCore::ConfigItem.new(key: :commit_hash,
                                   env_name: "BITBUCKET_ADD_TAG_COMMIT_HASH",
                                description: "Hash of the last commit",
                                   optional: false,
                                       type: String)

        ]
      end

      def self.is_supported?(platform)
        # Adjust this if your plugin only works for a particular platform (iOS vs. Android, for example)
        # See: https://docs.fastlane.tools/advanced/#control-configuration-by-lane-and-by-platform
        #
        # [:ios, :mac, :android].include?(platform)
        true
      end
    end
  end
end
