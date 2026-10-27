module TrackerApi
  module Resources
    class DailyHistoryContainer
      include Shared::Base

      attribute :project_id, Types::Integer
      attribute :iteration_number, Types::Integer
      attribute :header, Types::Array(Types::String)
      attribute :data, Types::Array(Types::Any)
      attribute :kind, Types::String
    end
  end
end
