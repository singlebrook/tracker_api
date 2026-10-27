module TrackerApi
  module Resources
    class StoryTransition
      include Shared::Base

      attribute :state, Types::String
      attribute :occurred_at, Types::DateTime
    end
  end
end
