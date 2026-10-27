module TrackerApi
  module Resources
    class CycleTimeDetails
      include Shared::Base

      attribute :project_id, Types::Integer
      attribute :iteration_number, Types::Integer
      attribute :total_cycle_time, Types::Integer
      attribute :started_time, Types::Integer
      attribute :started_count, Types::Integer
      attribute :finished_time, Types::Integer
      attribute :finished_count, Types::Integer
      attribute :delivered_time, Types::Integer
      attribute :delivered_count, Types::Integer
      attribute :rejected_time, Types::Integer
      attribute :rejected_count, Types::Integer
      attribute :story_id, Types::Integer
      attribute :kind, Types::String
    end
  end
end
