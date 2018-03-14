require 'fern/api'

module Fern
  module Documentation
    module Dsl
      def self.included(receiver)
        receiver.extend(ClassMethods)
      end

      module ClassMethods
      end

      def doc(str)
        @controller.fern[@name][:doc] = str
      end
    end
  end
end

Fern::Api::Endpoint.class_eval { include Fern::Documentation::Dsl }
