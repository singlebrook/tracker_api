module TrackerApi
  module Resources
    module Shared
      # Tracks attributes changed through their writers since the resource was built or last
      # marked clean. Resources start out clean, and should be marked clean whenever new data is
      # loaded from the server (e.g. Endpoints::Story#update).
      #
      # Original values are read from instance variables rather than readers, because resources
      # often override readers to lazily load associated data from the API (e.g. Project#epics).
      #
      # Based on https://github.com/ahawkins/virtus-dirty_attribute
      module DirtyTracking
        def initialize(*)
          super
          clean!
        end

        def dirty?
          dirty_attributes.any?
        end

        def clean?
          !dirty?
        end

        # @param [Symbol] name
        # @param [Hash] options
        # @option options :from only true if the attribute was changed from this value
        # @option options :to only true if the attribute was changed to this value
        def attribute_dirty?(name, options = {})
          result = dirty_attributes.key?(name)
          result &&= options[:to] == dirty_attributes[name] if options.key?(:to)
          result &&= options[:from] == original_attributes[name] if options.key?(:from)
          result
        end

        def clean!
          original_attributes.clear
          dirty_attributes.clear
        end

        # @return [Hash{Symbol => Object}] new (uncoerced) values of changed attributes
        def dirty_attributes
          @_dirty_attributes ||= {}
        end

        # @return [Hash{Symbol => Object}] values of changed attributes before they were changed
        def original_attributes
          @_original_attributes ||= {}
        end

        def attribute_dirty!(name, value)
          dirty_attributes[name] = value
        end

        def attribute_clean!(name)
          dirty_attributes.delete(name)
          original_attributes.delete(name)
        end

        private

        def write_attribute(name, value)
          previous = instance_variable_get(:"@#{name}")
          coerced = super

          if attribute_dirty?(name) && original_attributes[name] == coerced
            attribute_clean!(name)
          elsif previous != coerced
            original_attributes[name] = previous unless original_attributes.key?(name)
            attribute_dirty!(name, value)
          end

          coerced
        end
      end
    end
  end
end
