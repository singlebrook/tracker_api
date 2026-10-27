module TrackerApi
  module Resources
    class Activity
      include Shared::Base
      include Equalizer.new(:guid)

      attribute :client

      attribute :kind, Types::String
      attribute :guid, Types::String
      attribute :project_version, Types::Integer
      attribute :message, Types::String
      attribute :highlight, Types::String
      attribute :changes, Types::Array(Change)
      attribute :primary_resources, Types::Array(PrimaryResource)
      attribute :project, Project
      attribute :performed_by, Person
      attribute :occurred_at, Types::DateTime

      def project=(data)
        super.client = client
      end
    end
  end
end
