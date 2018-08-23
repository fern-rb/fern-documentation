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
{{/form}}

{{#key}}
### Key

`{{key}}`
{{/key}}
{{/has_form}}

{{#presenter}}
## Presenter

### Class

`{{presenter}}`
{{/presenter}}
).freeze

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
          doc: strip_leading_whitespace(@analysis[:doc]),
          has_parameters: params.present?,
          parameters: params,
          has_form: @analysis[:form].present?,
          form: @analysis[:form],
          presenter: @analysis[:presenter]
        ).gsub(/\n{2,}/, "\n\n")
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

      def strip_leading_whitespace(str)
        return nil if str.nil?
        
        lines = str.split("\n")
        first_line = lines.first
        first_line = lines.second if first_line == ''
        whitespace_to_trim = /^\s*/.match(first_line).to_s

        new_lines = []

        lines.each do |line|
          new_lines << line.sub(whitespace_to_trim, '')
        end
        
        new_lines.join("\n")
      end
    end
  end
end
