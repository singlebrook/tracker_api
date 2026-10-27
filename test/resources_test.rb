require_relative 'minitest_helper'

describe TrackerApi::Resources::Shared::Base do
  let(:story_class) { TrackerApi::Resources::Story }

  describe 'coercion' do
    it 'coerces attribute values with dry-types' do
      story = story_class.new('id' => '1', estimate: '2', created_at: '2024-01-02T03:04:05Z', label_ids: ['1', 2.0])

      _(story.id).must_equal 1
      _(story.estimate).must_equal 2.0
      _(story.created_at).must_equal DateTime.new(2024, 1, 2, 3, 4, 5)
      _(story.label_ids).must_equal [1, 2]
      _(TrackerApi::Resources::Task.new(complete: 'false').complete).must_equal false
    end

    it 'keeps values that cannot be coerced' do
      story = story_class.new(estimate: 'n/a', created_at: 'someday')

      _(story.estimate).must_equal 'n/a'
      _(story.created_at).must_equal 'someday'
    end

    it 'builds nested resources from hashes' do
      story = story_class.new('requested_by' => { 'id' => 1, 'name' => 'Luke' }, labels: [{ 'name' => 'jedi' }])

      _(story.requested_by).must_be_instance_of TrackerApi::Resources::Person
      _(story.requested_by.name).must_equal 'Luke'
      _(story.labels.map(&:class)).must_equal [TrackerApi::Resources::Label]
    end

    it 'nullifies blank values but keeps false' do
      story = story_class.new(name: '  ', labels: [], label_ids: nil)
      task = TrackerApi::Resources::Task.new(complete: false)

      _(story.name).must_be_nil
      _(story.labels).must_be_nil
      _(story.label_ids).must_be_nil
      _(task.complete).must_equal false
    end

    it 'ignores unknown attributes' do
      person = TrackerApi::Resources::Person.new(name: 'Luke', 'unknown' => 1)

      _(person.attributes).must_equal(id: nil, kind: nil, name: 'Luke', email: nil, initials: nil, username: nil)
    end

    it 'rejects unsupported attribute types' do
      _(-> { Class.new { include TrackerApi::Resources::Shared::Base; attribute :name, String } })
        .must_raise ArgumentError
    end
  end

  describe 'dirty tracking' do
    let(:story) { story_class.new(id: 1, name: 'Save the Ewoks', estimate: 1) }

    it 'starts clean' do
      _(story.dirty?).must_equal false
      _(story.dirty_attributes).must_be_empty
    end

    it 'tracks changed attributes' do
      story.name = 'Save Endor'
      story.estimate = '1'

      _(story.dirty?).must_equal true
      _(story.dirty_attributes).must_equal(name: 'Save Endor')
      _(story.original_attributes).must_equal(name: 'Save the Ewoks')
      _(story.attribute_dirty?(:name, from: 'Save the Ewoks', to: 'Save Endor')).must_equal true
    end

    it 'is clean again when an attribute is set back to its original value' do
      story.name = 'Save Endor'
      story.name = 'Save the Ewoks'

      _(story.dirty?).must_equal false
    end

    it 'tracks attributes assigned in bulk' do
      story.attributes = { 'name' => 'Save Endor', description: 'Yub nub' }

      _(story.dirty_attributes).must_equal(name: 'Save Endor', description: 'Yub nub')
    end
  end

  describe TrackerApi::Resources::TimeZone do
    it 'is a value object' do
      time_zone = TrackerApi::Resources::Project.new(time_zone: { 'offset' => '-05:00', 'olson_name' => 'America/New_York' }).time_zone

      _(time_zone).must_be_kind_of Dry::Struct
      _(time_zone).must_equal TrackerApi::Resources::TimeZone.new(offset: '-05:00', olson_name: 'America/New_York')
      _(time_zone.kind).must_be_nil
      _(time_zone).wont_respond_to :offset=
    end
  end

  describe TrackerApi::Resources::Iteration do
    it 'does not nullify blank values' do
      iteration = TrackerApi::Resources::Iteration.new(number: '3')

      _(iteration.number).must_equal 3
      _(iteration.stories).must_equal []
    end
  end
end
