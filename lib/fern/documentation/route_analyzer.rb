module Fern
  module Documentation
    class RouteAnalyzer
      def initialize(route)
        @route = route
      end

      def analyze
        return unless fern_controller?

        {
          verb: verb,
          path: path,
          controller_name: controller_name,
          controller: controller,
          action: action,
          params: fern[:params],
          doc: fern[:doc],
          form: fern[:form],
          presenter: fern[:presenter]
        }
      end

      private

      def action
        @route.defaults[:action]
      end

      def controller
        "#{controller_name.camelize}Controller".constantize
      rescue NameError
        nil
      end

      def controller_name
        @route.defaults[:controller]
      end

      def fern
        controller.fern[action.to_sym]
      end

      def fern_controller?
        controller&.method_defined?(:fern) && controller.fern.present?
      end

      def path
        match = /(^[^\(]+)\([^\)]+\)/.match(@route.path.spec.to_s)
        match[1] if match
      end

      def verb
        @route.verb
      end
    end
  end
end
