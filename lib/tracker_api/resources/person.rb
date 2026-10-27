module TrackerApi
  module Resources
    class Person
      include Shared::Base

      attribute :kind, Types::String
      attribute :name, Types::String
      attribute :email, Types::String
      attribute :initials, Types::String
      attribute :username, Types::String
    end
  end
end
