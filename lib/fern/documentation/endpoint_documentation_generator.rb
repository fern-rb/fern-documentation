require 'mustache'

module Fern
  module Documentation
    class EndpointDocumentationGenerator
      TEMPLATE = %(# {{verb}} {{path}}

_{{controller}}\#{{action}}_

{{doc}}

{{#has_parameters}}
## Parameters

| Name | Type | Array | Required | Min | Max | Values | Default |
| ---- | ---- | ----- | -------- | --- | --- | ------ | ------- |
{{#parameters}}
| {{name}} | `{{ type }}` | {{ array }} | {{ required }} | {{ min }} | {{ max }} | {{ values }} | {{ default }} |
{{/parameters}}
{{/has_parameters}}).freeze

      def initialize(analysis)
        @analysis = analysis
      end

      def generate
        params = build_params

        Mustache.render(
          TEMPLATE,
          verb: @analysis[:verb],
          path: @analysis[:path],
          controller: @analysis[:controller],
          action: @analysis[:action],
          doc: @analysis[:doc],
          has_parameters: params.present?,
          parameters: params
        )
      end

      private

      def build_params
        return if @analysis[:params].nil?
        @analysis[:params].map { |name, config| build_param(name, config) }
      end

      def build_param(name, config)
        constraints = config[:constraints]
        {
          name: name,
          type: config[:type],
          array: check(constraints[:array]),
          required: check(constraints[:required]),
          min: constraints[:min],
          max: constraints[:max],
          values: constraints[:values].join(', '),
          default: constraints[:default]
        }
      end

      def check(val)
        val ? '✓' : ''
      end
    end
  end
end
