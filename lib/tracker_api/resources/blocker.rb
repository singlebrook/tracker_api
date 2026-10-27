module TrackerApi
  module Resources
    class Blocker
      include Shared::Base

      attribute :client
      attribute :project_id, Types::Integer

      attribute :story_id, Types::Integer
      attribute :person_id, Types::Integer
      attribute :description, Types::String
      attribute :resolved, Types::Boolean
      attribute :created_at, Types::DateTime
      attribute :updated_at, Types::DateTime
      attribute :kind, Types::String
    end
  end
end
