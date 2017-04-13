require "casify/version"
require "omniauth-cas"
require "httparty"
require "casify/auth_controller"
require "casify/user"
module Casify

  class Configuration
    attr_accessor :cas_url
  end

  class << self

    attr_accessor :configuration

    def configure
      self.configuration ||= Configuration.new
      yield(configuration) if block_given?
    end

  end

end
