require 'fileutils'

require 'fern/documentation/route_analyzer'
require 'fern/documentation/markdown_generator'

namespace :fern do
  desc 'Generate documentation'
  task docs: :environment do
    endpoints = []

    Rails.application.routes.routes.each do |route|
      next if route.internal

      analysis = Fern::Documentation::RouteAnalyzer.new(route).analyze

      unless analysis.nil?
        endpoints << analysis
      end
    end

    doc_root = Rails.root.join('docs', 'api')

    FileUtils.rm_rf(doc_root)
    FileUtils.mkdir_p(doc_root)

    endpoints.each do |endpoint|
      filename = "#{endpoint[:controller_name]}-#{endpoint[:action]}.md"
      filepath = File.join(doc_root, filename)
      filedir = File.dirname(filepath)
      FileUtils.mkdir_p(filedir)
      content = Fern::Documentation::MarkdownGenerator.new(endpoint).generate
      File.write(filepath, content)
    end
  end
end
