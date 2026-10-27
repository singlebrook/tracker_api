module TrackerApi
  module Resources
    class Epic
      include Shared::Base

      attribute :client

      attribute :comment_ids, Types::Array(Types::Integer)
      attribute :comments, Types::Array(Comment)
      attribute :created_at, Types::DateTime
      attribute :description, Types::String
      attribute :follower_ids, Types::Array(Types::Integer)
      attribute :followers, Types::Array(Person)
      attribute :kind, Types::String
      attribute :label, Label
      attribute :label_id, Types::Integer
      attribute :name, Types::String
      attribute :project_id, Types::Integer
      attribute :updated_at, Types::DateTime
      attribute :completed_at, Types::DateTime
      attribute :projected_completion, Types::DateTime
      attribute :url, Types::String

      class UpdateRepresenter < Representable::Decorator
        include Representable::Hash

        property :name
        property :description
        property :label, class: Label, decorator: Label::UpdateRepresenter, render_empty: true
      end

      # Save changes to an existing Epic.
      def save
        raise ArgumentError, 'Can not update an epic with an unknown project_id.' if project_id.nil?

        Endpoints::Epic.new(client).update(self, UpdateRepresenter.new(self))
      end

      # Provides a list of all the comments on the epic.
      def comments(reload: false)
        if !reload && @comments.present?
          @comments
        else
          @comments = Endpoints::Comments.new(client).get(project_id, epic_id: id)
        end
      end

      # @param [Hash] params attributes to create the comment with
      # @return [Comment] newly created Comment
      def create_comment(params)
        files = params.delete(:files)
        comment = Endpoints::Comment.new(client).create(project_id, epic_id: id, params: params)
        comment.create_attachments(files: files) if files.present?
        comment
      end
    end
  end
end
