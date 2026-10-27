module TrackerApi
  module Resources
    class Me
      include Shared::Base

      attribute :name, Types::String
      attribute :initials, Types::String
      attribute :username, Types::String
      attribute :time_zone, TimeZone
      attribute :api_token, Types::String
      attribute :has_google_identity, Types::Boolean
      attribute :project_ids, Types::Array(Types::Integer)
      attribute :projects, Types::Array(MembershipSummary)
      attribute :workspace_ids, Types::Array(Types::Integer)
      attribute :workspaces, Types::Array(Workspace)
      attribute :email, Types::String
      attribute :receives_in_app_notifications, Types::Boolean
      attribute :kind, Types::String
    end
  end
end
