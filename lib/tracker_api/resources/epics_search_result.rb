module TrackerApi
  module Resources
    class EpicsSearchResult
      include Shared::Base

      attribute :epics, Types::Array(Resources::Epic)
      attribute :total_hits, Types::Integer
      attribute :total_hits_with_done, Types::Integer
      attribute :kind, Types::String
    end
  end
end
