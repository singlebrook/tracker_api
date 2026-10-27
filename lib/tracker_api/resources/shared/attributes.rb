module TrackerApi
  module Resources
    module Shared
      # Mutable, typed attributes for resources.
      #
      # Values are coerced with dry-types (see TrackerApi::Types) whenever an attribute is written.
      # Input hashes are normalized with a dry-schema that symbolizes keys and drops unknown keys.
      #
      # Accessors are defined in a module included into the resource class, so a resource can
      # override a reader/writer and call `super`.
      module Attributes
        def self.included(base)
          base.extend(ClassMethods)
        end

        module ClassMethods
          # Defines a typed attribute with a reader and a coercing writer.
          #
          # @param [Symbol] name
          # @param [Dry::Types::Type, Class] type a dry-type or a resource class
          def attribute(name, type = Types::Any)
            name = name.to_sym
            attribute_types[name] = Types[type]
            @input_schema = nil

            ivar = :"@#{name}"
            attribute_methods.module_eval do
              define_method(name) { instance_variable_get(ivar) }
              define_method(:"#{name}=") { |value| write_attribute(name, value) }
            end
          end

          # @return [Hash{Symbol => Dry::Types::Type}]
          def attribute_types
            @attribute_types ||= superclass.respond_to?(:attribute_types) ? superclass.attribute_types.dup : {}
          end

          # @return [Array<Symbol>]
          def attribute_names
            attribute_types.keys
          end

          # @return [Dry::Schema::Params] schema used to normalize input hashes
          def input_schema
            @input_schema ||= begin
              names = attribute_names
              Dry::Schema.Params do
                names.each { |name| optional(name).value(Types::Any) }
              end
            end
          end

          private

          def attribute_methods
            @attribute_methods ||= Module.new.tap { |mod| include mod }
          end
        end

        # @param [Hash] attributes attribute values, with String or Symbol keys
        def initialize(attributes = nil)
          self.attributes = attributes unless attributes.nil?
          set_default_attributes
        end

        # Assigns attributes through their public writers. Unknown keys are ignored.
        #
        # @param [Hash] attributes attribute values, with String or Symbol keys
        def attributes=(attributes)
          hash = ::Hash.try_convert(attributes) or
            raise NoMethodError, "Expected #{attributes.inspect} to respond to #to_hash"

          self.class.input_schema.call(hash).to_h.each do |name, value|
            public_send(:"#{name}=", value)
          end
        end

        # @return [Hash{Symbol => Object}] attribute values read through their public readers
        def attributes
          self.class.attribute_names.to_h { |name| [name, public_send(name)] }
        end
        alias_method :to_h, :attributes

        def [](name)
          public_send(name)
        end

        def []=(name, value)
          public_send(:"#{name}=", value)
        end

        private

        def coerce_attribute(name, value)
          self.class.attribute_types.fetch(name).call(value)
        end

        def write_attribute(name, value)
          instance_variable_set(:"@#{name}", coerce_attribute(name, value))
        end

        def set_default_attributes
          self.class.attribute_names.each do |name|
            ivar = :"@#{name}"
            instance_variable_set(ivar, coerce_attribute(name, nil)) unless instance_variable_defined?(ivar)
          end
        end
      end
    end
  end
end
