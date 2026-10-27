module TrackerApi
  module Resources
    class Story
      include Shared::Base

      attribute :client

      attribute :accepted_at, Types::DateTime
      attribute :after_id, Types::Integer
      attribute :before_id, Types::Integer
      attribute :blockers, Types::Array(Blocker)
      attribute :comment_ids, Types::Array(Types::Integer)
      attribute :comments, Types::Array(Comment)
      attribute :created_at, Types::DateTime
      attribute :current_state, Types::String # (accepted, delivered, finished, started, rejected, planned, unstarted, unscheduled)
      attribute :deadline, Types::DateTime
      attribute :description, Types::String
      attribute :estimate, Types::Float
      attribute :external_id, Types::String
      attribute :follower_ids, Types::Array(Types::Integer)
      attribute :followers, Types::Array(Person)
      attribute :integration_id, Types::Integer
      attribute :kind, Types::String
      attribute :label_ids, Types::Array(Types::Integer)
      attribute :labels, Types::Array(Label)
      attribute :name, Types::String
      attribute :owned_by_id, Types::Integer # deprecated!
      attribute :owned_by, Person
      attribute :owner_ids, Types::Array(Types::Integer)
      attribute :owners, Types::Array(Person)
      attribute :planned_iteration_number, Types::Integer
      attribute :project_id, Types::Integer
      attribute :pull_requests, Types::Array(PullRequest)
      attribute :requested_by, Person
      attribute :requested_by_id, Types::Integer
      attribute :reviews, Types::Array(Review)
      attribute :story_type, Types::String # (feature, bug, chore, release)
      attribute :task_ids, Types::Array(Types::Integer)
      attribute :tasks, Types::Array(Task)
      attribute :transitions, Types::Array(StoryTransition)
      attribute :updated_at, Types::DateTime
      attribute :url, Types::String


      class UpdateRepresenter < Representable::Decorator
        include Representable::Hash

        property :follower_ids, if: ->(_) { !follower_ids.blank? }
        property :name
        property :after_id
        property :before_id
        property :description
        property :story_type
        property :current_state
        property :estimate
        property :accepted_at
        property :deadline
        property :requested_by_id
        property :owner_ids, if: ->(_) { !owner_ids.blank? }
        property :project_id

        # Use render_empty: false to address: https://github.com/dashofcode/tracker_api/issues/110
        # - The default value of the labels attribute in Resources::Story is an empty array.
        # - If the value of labels is not change (i.e. not dirty) then when a new Story
        #   is created from the dirty attributes in the save method the labels attributes becomes
        #   an empty array again. render_empty: false keeps this from rendering in the json passed
        #   in the API PUT request. It is is empty then the labels will be cleared.
        # - The next issue is that there is no way to delete all the labels from a Story with
        #   the current implementation.
        #
        # NOTE: The solution would be to remove dirty tracking.
        # SEE: https://github.com/dashofcode/tracker_api/pull/98
        collection :labels, class: Label, decorator: Label::UpdateRepresenter, render_empty: false

        property :integration_id
        property :external_id
      end

      # @return [String] Comma separated list of labels.
      def label_list
        @label_list ||= begin
          return if labels.nil?
          labels.collect(&:name).join(',')
        end
      end

      # Adds a new label to the story.
      #
      # @param [Label|Hash|String] label
      def add_label(label)
        new_label = if label.kind_of?(String)
          Label.new(name: label)
        else
          label
        end

        # Use attribute writer to get coercion and dirty tracking.
        self.labels = (labels ? labels.dup : []).push(new_label).uniq
      end

      # Adds a new owner to the story.
      #
      # @param [Person|Fixnum] owner
      def add_owner(owner)
        owner_id = if owner.kind_of?(Integer)
          owner_id = owner
        else
          raise ArgumentError, 'Valid Person expected.' unless owner.instance_of?(Resources::Person)
          owner_id = owner.id
        end

        # Use attribute writer to get coercion and dirty tracking.
        self.owner_ids = (owner_ids ? owner_ids.dup : []).push(owner_id).uniq
      end

      # Provides a list of all the activity performed on the story.
      #
      # @param [Hash] params
      # @return [Array[Activity]]
      def activity(params = {})
        Endpoints::Activity.new(client).get_story(project_id, id, params)
      end

      def blockers(params = {})
        Endpoints::Blockers.new(client).get(project_id, id, params)
      end

      # Provides a list of all the comments on the story.
      #
      # @param [Hash] params
      # @return [Array[Comment]]
      def comments(reload: false)
        if !reload && @comments.present?
          @comments
        else
          @comments = Endpoints::Comments.new(client).get(project_id, story_id: id)
        end
      end

      # Provides a list of all the tasks on the story.
      #
      # @param [Hash] params
      # @return [Array[Task]]
      def tasks(params = {})
        if params.blank? && @tasks.present?
          @tasks
        else
          @tasks = Endpoints::Tasks.new(client).get(project_id, id, params)
        end
      end

      # Provides a list of all the owners of the story.
      #
      # @param [Hash] params
      # @return [Array[Person]]
      def owners(params = {})
        if params.blank? && @owners.present?
          @owners
        else
          @owners = Endpoints::StoryOwners.new(client).get(project_id, id, params)
        end
      end

      # Provides a list of all the transitions of the story.
      #
      # @param [Hash] params
      # @return [Array[StoryTransition]]
      def transitions(params = {})
        if params.blank? && @transitions.present?
          @transitions
        else
          @transitions = Endpoints::StoryTransitions.new(client).get(project_id, id, params)
        end
      end

      # Returns the story's original ("undirtied") project_id
      #
      # @return Integer
      def project_id
        if dirty_attributes.key?(:project_id)
          original_attributes[:project_id]
        else
          @project_id
        end
      end

      # @param [Hash] params attributes to create the task with
      # @return [Task] newly created Task
      def create_task(params)
        Endpoints::Task.new(client).create(project_id, id, params)
      end

      # @param [Hash] params attributes to create the comment with
      # @return [Comment] newly created Comment
      def create_comment(params)
        files = params.delete(:files)
        comment = Endpoints::Comment.new(client).create(project_id, story_id: id, params: params)
        comment.create_attachments(files: files) if files.present?
        comment
      end

      # Save changes to an existing Story.
      def save
        raise ArgumentError, 'Can not update a story with an unknown project_id.' if project_id.nil?
        return self unless dirty?

        Endpoints::Story.new(client).update(self, UpdateRepresenter.new(Story.new(self.dirty_attributes)))
      end

      def reviews(params = {})
          if params.blank? && @reviews.present?
            @reviews
          else
            @reviews = Endpoints::Reviews.new(client).get(project_id, id, params)
          end
      end
    end
  end
end
