module TrackerApi
  module Resources
    class Account
      include Shared::Base

      attribute :created_at, Types::DateTime
      attribute :status, Types::String
      attribute :kind, Types::String
      attribute :name, Types::String
      attribute :updated_at, Types::DateTime
      attribute :url, Types::String
      attribute :plan, Types::String
      attribute :days_left, Types::Integer
      attribute :over_the_limit, Types::Boolean
    end
  end
end
