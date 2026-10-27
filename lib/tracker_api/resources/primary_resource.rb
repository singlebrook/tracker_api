module TrackerApi
  module Resources
    class PrimaryResource
      include Shared::Base

      attribute :kind, Types::String
      attribute :name, Types::String
      attribute :story_type, Types::String
      attribute :url, Types::String
    end
  end
end