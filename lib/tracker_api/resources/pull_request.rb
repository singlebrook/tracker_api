module TrackerApi
  module Resources
    class PullRequest
      include Shared::Base

      attribute :client

      attribute :id, Types::Integer
      attribute :story_id, Types::Integer
      attribute :epic_id, Types::Integer
      attribute :owner, Types::String
      attribute :repo, Types::String
      attribute :number, Types::Integer
      attribute :host_url, Types::String
      attribute :original_url, Types::String
      attribute :status, Types::String
      attribute :created_at, Types::DateTime
      attribute :updated_at, Types::DateTime
      attribute :kind, Types::String
    end
  end
end
