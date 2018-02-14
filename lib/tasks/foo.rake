require 'fileutils'

require 'fern/documentation/route_analyzer'
require 'fern/documentation/endpoint_documentation_generator'

namespace :fern do
  desc 'Generate documentation'
  task docs: :environment do
    endpoints = []

    Rails.application.routes.routes.each do |route|
      next if route.internal
      endpoints << RouteAnalyzer.new(route).analyze
    end

    doc_root = Rails.root.join('docs', 'api')

    FileUtils.rm_rf(doc_root)
    FileUtils.mkdir(doc_root)

    endpoints.each do |endpoint|
      filename = "#{endpoint[:controller_name]}-#{endpoint[:action]}.md"
      content = EndpointDocumentationGenerator.new(endpoint).generate
      File.write(File.join(doc_root, filename), content)
    end
  end
end
