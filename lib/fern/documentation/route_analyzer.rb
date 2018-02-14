module Fern
  module Documentation
    class RouteAnalyzer
      def initialize(route)
        @route = route
      end

      def analyze
        {
          verb: verb,
          path: path,
          controller_name: controller_name,
          controller: controller,
          action: action,
          params: fern[:params],
          desc: fern[:desc]
        }
      end

      private

      def action
        @route.defaults[:action]
      end

      def controller
        "#{controller_name.camelize}Controller".constantize
      end

      def controller_name
        @route.defaults[:controller]
      end

      def fern
        controller.fern[action.to_sym]
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
