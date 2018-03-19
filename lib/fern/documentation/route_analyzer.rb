module Fern
  module Documentation
    class RouteAnalyzer
      def initialize(route)
        @route = route
      end

      def analyze
      	return nil if path.nil? || !defined?(controller.fern)

        puts "Analyzing #{path}"

        result = {
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
        if fern[:form].present?
          result[:form_schema] = fern[:form][:klass].schema
        end
        result
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
