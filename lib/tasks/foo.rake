require 'fileutils'

require 'mustache'

namespace :fern do
  desc 'Generate documentation'
  task docs: :environment do
    endpoints = []

    Rails.application.routes.routes.each do |route|
      next if route.internal

      path = strip_format(route.path.spec.to_s)
      verb = route.verb
      controller_name = route.defaults[:controller]
      controller = "#{controller_name.camelize}Controller".constantize
      action = route.defaults[:action]
      fern = controller.fern[action.to_sym]

      endpoints << {
        verb: verb,
        path: path,
        controller_name: controller_name,
        controller: controller,
        action: action,
        params: fern[:params],
        doc: fern[:doc]
      }
    end

    doc_root = Rails.root.join('doc')

    FileUtils.rm_rf(doc_root)
    FileUtils.mkdir(doc_root)

    endpoints.each do |endpoint|
      params = []
      (endpoint[:params] || {}).each do |name, config|
        params << {
          name: name,
          type: config[:type],
          array: config[:constraints][:array] ? '✓' : '',
          required: config[:constraints][:required] ? '✓' : '',
          min: config[:constraints][:min],
          max: config[:constraints][:max],
          values: config[:constraints][:values]&.join(', '),
          default: config[:constraints][:default]
        }
      end

      tmpl = %(# {{verb}} {{path}}

_{{controller}}\#{{action}}_

{{doc}}

{{#has_parameters}}
## Parameters

| Name | Type | Array | Required | Min | Max | Values | Default |
| ---- | ---- | ----- | -------- | --- | --- | ------ | ------- |
{{#parameters}}
| {{name}} | `{{ type }}` | {{ array }} | {{ required }} | {{ min }} | {{ max }} | {{ values }} | {{ default }} |
{{/parameters}}
{{/has_parameters}})
      content = Mustache.render(
        tmpl,
        {
          verb: endpoint[:verb],
          path: endpoint[:path],
          has_parameters: params.present?,
          parameters: params,
          controller: endpoint[:controller],
          action: endpoint[:action],
          doc: endpoint[:doc]
        }
      )

      filename = "#{endpoint[:controller_name]}-#{endpoint[:action]}.md"

      File.write(File.join(doc_root, filename), content)
    end
  end
end

INITIAL_SEGMENT_REGEX = %r{(^[^\(]+)\([^\)]+\)}

def strip_format(path)
  if match = INITIAL_SEGMENT_REGEX.match(path)
    match[1]
  end
end
