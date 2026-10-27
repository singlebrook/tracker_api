module TrackerApi
  module Resources
    class Iteration
      include Shared::Attributes
      include Equalizer.new(:number, :project_id)

      attribute :client

      attribute :finish, Types::DateTime
      attribute :kind, Types::String
      attribute :length, Types::Integer
      attribute :number, Types::Integer
      attribute :planned, Types::Boolean
      attribute :project_id, Types::Integer
      attribute :start, Types::DateTime
      attribute :stories, Types::Array(Story)
      attribute :story_ids, Types::Array(Types::Integer)
      attribute :team_strength, Types::Float
      attribute :velocity, Types::Float
      attribute :points, Types::Integer
      attribute :accepted_points, Types::Integer
      attribute :effective_points, Types::Float

      def stories=(data)
        super.each { |s| s.client = client }
      end

      # Provides a list of all the cycle_time_details of each story in the iteration.
      #
      # @return [Array[CycleTimeDetails]] array of cycle_time_details of iterations in this project
      def cycle_time_details
        Endpoints::Iteration.new(client).get_analytics_cycle_time_details(project_id, number)
      end

      # Returns per day information of story points and counts by state for the given iteration.
      #
      # @return [DailyHistoryContainer]
      def get_history
        Endpoints::Iteration.new(client).get_history(project_id, number)
      end
    end
  end
end
