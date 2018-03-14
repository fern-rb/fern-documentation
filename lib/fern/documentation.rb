require 'fern/documentation/dsl'
require 'fern/documentation/railtie' if defined?(Rails)

ActiveSupport.on_load(:action_controller) { include Fern::Documentation }
