module TrackerApi
  module Resources
    class Notification
      include Shared::Base

      attribute :client

      attribute :message, Types::String
      attribute :context, Types::String
      attribute :kind, Types::String
      attribute :project, Project
      attribute :story, Story
      attribute :performer, Person
      attribute :created_at, Types::DateTime
      attribute :updated_at, Types::DateTime

      def project=(data)
        super.client = client
      end

      def story=(data)
        super.client = client
      end
    end
  end
end
