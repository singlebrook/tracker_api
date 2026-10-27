module TrackerApi
  module Resources
    class ReviewType
      include Shared::Base

      attribute :id, Types::Integer
      attribute :project_id, Types::Integer
      attribute :name, Types::String
      attribute :hidden, Types::Boolean
      attribute :created_at, Types::DateTime
      attribute :updated_at, Types::DateTime
      attribute :kind, Types::String
    end
  end
end