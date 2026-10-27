module TrackerApi
  module Resources
    class Task
      include Shared::Base

      attribute :client

      attribute :project_id, Types::Integer
      attribute :story_id, Types::Integer
      attribute :description, Types::String
      attribute :complete, Types::Boolean
      attribute :position, Types::Integer
      attribute :created_at, Types::DateTime
      attribute :updated_at, Types::DateTime
      attribute :kind, Types::String

      class UpdateRepresenter < Representable::Decorator
        include Representable::Hash

        property :id
        property :description
        property :complete
        property :position
      end

      def save
        raise ArgumentError, 'Cannot update a task with an unknown project_id.' if project_id.nil?
        raise ArgumentError, 'Cannot update a task with an unknown story_id.' if story_id.nil?

        Endpoints::Task.new(client).update(self, UpdateRepresenter.new(Task.new(self.dirty_attributes)))
      end
    end
  end
end
