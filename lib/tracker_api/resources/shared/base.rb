module TrackerApi
  module Resources
    module Shared
      module Base
        def self.included(base)
          base.class_eval do
            include Attributes
            include NullifyBlank
            include DirtyTracking

            include Equalizer.new(:id)

            attribute :id, Types::Integer
          end
        end
      end
    end
  end
end
