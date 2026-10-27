module TrackerApi
  module Resources
    class Review
      include Shared::Base

      attribute :client

      attribute :id, Types::Integer
      attribute :story_id, Types::Integer
      attribute :project_id, Types::Integer
      attribute :review_type_id, Types::Integer
      attribute :reviewer_id, Types::Integer
      attribute :status, Types::String # (unstarted, in_review, pass, revise)
      attribute :created_at, Types::DateTime
      attribute :updated_at, Types::DateTime
      attribute :kind, Types::String
      attribute :review_type, ReviewType

      class UpdateRepresenter < Representable::Decorator
        include Representable::Hash

        property :id
        property :review_type_id
        property :reviewer_id
        property :status
      end

      def save
        raise ArgumentError, 'Cannot update a review with an unknown story_id.' if story_id.nil?

        Endpoints::Review.new(client).update(self, UpdateRepresenter.new(Review.new(dirty_attributes)))
      end
    end
  end
end
