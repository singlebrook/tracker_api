module TrackerApi
  module Resources
    class Change
      include Shared::Base

      attribute :change_type, Types::String
      attribute :kind, Types::String
      attribute :name, Types::String
      attribute :new_values, Types::Hash
      attribute :original_values, Types::Hash
      attribute :story_type, Types::String
    end
  end
end
