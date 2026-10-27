module TrackerApi
  module Resources
    class Workspace
      include Shared::Base

      attribute :client

      attribute :person, Person
      attribute :person_id, Types::Integer
      attribute :created_at, Types::DateTime
      attribute :project_ids, Types::Array(Types::Integer)
      attribute :projects, Types::Array(Project)
      attribute :kind, Types::String
      attribute :name, Types::String

    end
  end
end
