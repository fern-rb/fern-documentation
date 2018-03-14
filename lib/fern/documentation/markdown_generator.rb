require 'mustache'

module Fern
  module Documentation
    class MarkdownGenerator
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
{{/has_parameters}}

{{#has_form}}
## Form

{{#form}}
### Class

`{{klass}}`

{{#key}}
### Key

`{{key}}`
{{/key}}
{{/form}}

{{#presenter}}
## Presenter

### Class

`{{presenter}}`
{{/presenter}}
{{/has_form}}).freeze

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
          parameters: params,
          has_form: @analysis[:form].present?,
          form: @analysis[:form],
          presenter: @analysis[:presenter]
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
          values: constraints[:values]&.join(', '),
          default: constraints[:default]
        }
      end

      def check(val)
        val ? '✓' : ''
      end
    end
  end
end
