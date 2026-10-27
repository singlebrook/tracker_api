module TrackerApi
  module Resources
    module Shared
      # Stores blank attribute values (e.g. "", [], {}) as nil. `false` is kept.
      module NullifyBlank
        private

        def coerce_attribute(name, value)
          output = super
          output.blank? && output != false ? nil : output
        end
      end
    end
  end
end
