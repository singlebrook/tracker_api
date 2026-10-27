module TrackerApi
  # Attribute types used by resources, built on dry-types.
  #
  # Coercion is intentionally lenient: the Pivotal Tracker API payload is outside of our control,
  # so a value that can't be coerced is kept as-is instead of raising, and nil is passed through.
  module Types
    DryTypes = ::Dry.Types()

    STRINGABLE = [::String, ::Symbol, ::Numeric, ::TrueClass, ::FalseClass].freeze

    # Wraps a dry-type so that failed coercions fall back to the given block (or the raw input).
    #
    # @param [Dry::Types::Type] type
    # @param [Array<Class>] only coerce only instances of these classes; keep anything else as-is
    # @return [Dry::Types::Type]
    def self.lenient(type, only: nil, &fallback)
      fallback ||= ->(input) { input }

      DryTypes::Nominal::Any.constructor do |input|
        if input.nil? || (only && only.none? { |klass| klass === input })
          input
        else
          type.call(input) { fallback.call(input) }
        end
      end
    end

    Any = DryTypes::Nominal::Any

    String = lenient(DryTypes::Coercible::String, only: STRINGABLE)

    # Kernel#Integer rejects decimal strings such as "1.5", so truncate them through Float.
    Integer = lenient(DryTypes::Coercible::Integer) do |input|
      float = DryTypes::Coercible::Float.call(input) { nil }
      float&.finite? ? float.to_i : input
    end

    Float = lenient(DryTypes::Coercible::Float)

    Boolean = lenient(DryTypes::Params::Bool)

    DateTime = lenient(DryTypes::Params::DateTime) do |input|
      case input
      when ::Date, ::Time then input.to_datetime
      when ::Integer then ::Time.at(input).utc.to_datetime
      else input
      end
    end

    Hash = lenient(DryTypes::Strict::Hash) do |input|
      begin
        input.respond_to?(:to_h) ? input.to_h : input
      rescue ::TypeError, ::ArgumentError
        input
      end
    end

    # A collection whose members are coerced with the given type or resource class.
    # Non-array input is wrapped with Kernel#Array (so nil becomes an empty array).
    #
    # @param [Dry::Types::Type, Class] member
    # @return [Dry::Types::Type]
    def self.Array(member)
      DryTypes::Nominal::Array.of(self[member]).constructor { |input| ::Kernel.Array(input) }
    end

    # A nested resource built from a Hash of attributes.
    #
    # @param [Class] klass a resource class (Shared::Attributes or Dry::Struct)
    # @return [Dry::Types::Type]
    def self.Resource(klass)
      DryTypes::Nominal::Any.constructor do |input|
        input.nil? || klass === input ? input : klass.new(input)
      end
    end

    # Resolves an attribute type declaration to a dry-type.
    #
    # @param [Dry::Types::Type, Class] type a dry-type or a resource class
    # @return [Dry::Types::Type]
    def self.[](type)
      return type if type.is_a?(::Dry::Types::Type)
      return Resource(type) if resource_class?(type)

      raise ArgumentError, "Unsupported attribute type #{type.inspect}; use a TrackerApi::Types type or a resource class"
    end

    def self.resource_class?(type)
      type.is_a?(::Class) &&
        (type < ::Dry::Struct || type.include?(Resources::Shared::Attributes))
    end
    private_class_method :resource_class?
  end
end
