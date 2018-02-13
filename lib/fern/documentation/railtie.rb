class Fern::Documentation::Railtie < Rails::Railtie
  rake_tasks do
    load 'tasks/foo.rake'
  end
end