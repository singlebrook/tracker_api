module TrackerApi
  module Resources
    class StoriesSearchResult
      include Shared::Base

      attribute :stories, Types::Array(Resources::Story)
      attribute :total_hits, Types::Integer
      attribute :total_hits_with_done, Types::Integer
      attribute :total_points, Types::Float
      attribute :total_points_completed, Types::Float
      attribute :kind, Types::String
    end
  end
end
