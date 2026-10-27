module TrackerApi
  module Resources
    class MembershipSummary
      include Shared::Base

      attribute :kind, Types::String
      attribute :last_viewed_at, Types::DateTime
      attribute :project_color, Types::String
      attribute :project_id, Types::Integer
      attribute :project_name, Types::String
      attribute :role, Types::String
    end
  end
end
