module TrackerApi
  module Resources
    class Release
      include Shared::Base

      attribute :client

      attribute :project_id, Types::Integer
      attribute :name, Types::String
      attribute :description, Types::String
      attribute :current_state, Types::String # (accepted, delivered, finished, started, rejected, planned, unstarted, unscheduled)
      attribute :accepted_at, Types::DateTime
      attribute :deadline, Types::DateTime
      attribute :labels, Types::Array(Label)
      attribute :created_at, Types::DateTime
      attribute :updated_at, Types::DateTime
      attribute :url, Types::String
      attribute :kind, Types::String

      # Provides a list of all the stories in the release.
      #
      # @param [Hash] params
      # @return [Array[Story]] stories of this release
      def stories(params={})
        Endpoints::Stories.new(client).get_release(project_id, id, params)
      end
    end
  end
end
