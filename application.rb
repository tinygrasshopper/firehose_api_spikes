require "rubygems"
require "bundler"

module PocEMRuby
  class Application

    def self.root(path = nil)
      @_root ||= File.expand_path(File.dirname(__FILE__))
      path ? File.join(@_root, path.to_s) : @_root
    end

    def self.env
      @_env ||= ENV['RACK_ENV'] || 'development'
    end

    def self.routes
      @_routes ||= eval(File.read(File.expand_path('../config/routes.rb', __FILE__)))
    end

    # Initialize the application
    def self.initialize!
    end

  end
end

Bundler.require(:default, PocEMRuby::Application.env)

# Preload application classes
Dir[File.join(File.dirname(__FILE__), 'app/**/*.rb')].each {| f| require f }
