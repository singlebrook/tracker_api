module TrackerApi
  module Resources
    class ProjectMembership
      include Shared::Base

      attribute :person_id, Types::Integer
      attribute :project_id, Types::Integer
      attribute :role, Types::String
      attribute :project_color, Types::String
      attribute :wants_comment_notification_emails, Types::Boolean
      attribute :kind, Types::String
      attribute :person, Person
    end
  end
end
