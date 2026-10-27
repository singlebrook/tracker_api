module TrackerApi
  module Resources
    class Webhook
      include Shared::Base

      attribute :client

      attribute :kind, Types::String
      attribute :project_id, Types::Integer
      attribute :webhook_url, Types::String
      attribute :webhook_version, Types::String
      attribute :created_at, Types::DateTime
      attribute :updated_at, Types::DateTime

      class UpdateRepresenter < Representable::Decorator
        include Representable::Hash

        property :project_id
        property :webhook_url
        property :webhook_version
      end

      def delete
        raise ArgumentError, 'Can not delete a webhook with an unknown project_id.' if project_id.nil?

        Endpoints::Webhook.new(client).delete(self)
      end

      # Save changes to an existing Webhook.
      def save
        raise ArgumentError, 'Can not update a webhook with an unknown project_id.' if project_id.nil?

        Endpoints::Webhook.new(client).update(self, UpdateRepresenter.new(Webhook.new(self.dirty_attributes)))
      end
    end
  end
end
