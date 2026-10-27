module TrackerApi
  module Resources
    class Label
      include Shared::Base

      attribute :created_at, Types::DateTime
      attribute :kind, Types::String
      attribute :name, Types::String
      attribute :project_id, Types::Integer
      attribute :updated_at, Types::DateTime

      class UpdateRepresenter < Representable::Decorator
        include Representable::Hash

        property :id
        property :name
      end
    end
  end
end
