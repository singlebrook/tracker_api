module TrackerApi
  module Resources
    class TimeZone < Dry::Struct
      transform_keys(&:to_sym)

      attribute :offset, Types::String.default(nil)
      attribute :olson_name, Types::String.default(nil)
      attribute :kind, Types::String.default(nil)
    end
  end
end
