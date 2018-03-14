module Fern
  module Documentation
    class Railtie < Rails::Railtie
      rake_tasks do
        load 'tasks/docs.rake'
      end
    end
  end
end
