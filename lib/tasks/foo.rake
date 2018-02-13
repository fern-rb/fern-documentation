namespace :fern do
  desc 'Generate documentation'
  task docs: :environment do
    Rails.application.routes.routes.each do |route|
      puts route.path.spec.to_s
    end
  end
end