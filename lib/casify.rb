require "casify/version"
require "omniauth-cas"
require "httparty"
require "casify/auth_controller"
require "casify/user"
module Casify

  def self.configure(values={})
    str_config = values.map{|k,v| {k.downcase.to_s => v}}.reduce(&:merge)

    @@auth_exp = (str_config['auth_exp'] || 3).to_i.seconds
  end

  def self.auth_exp
    @@auth_exp
  end

end
