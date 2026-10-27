module TrackerApi
  module Resources
    class SearchResultContainer
      include Shared::Base

      attribute :query, Types::String
      attribute :stories, Resources::StoriesSearchResult
      attribute :epics, Resources::EpicsSearchResult
      attribute :kind, Types::String
    end
  end
end
