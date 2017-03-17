require "casify/version"
require "omniauth-cas"
require "httparty"
require "casify/auth_controller"
require "casify/user"
module Casify

  def self.configure(values={})
    str_config = values.map{|k,v| {k.downcase.to_s => v}}.reduce(&:merge)

    @@authz_url = str_config['authz_url'].to_s || ""
    @@authn_exp = (str_config['authn_exp'] || 3).to_i.seconds
    @@authz_exp = (str_config['authz_exp'] || 180).to_i.second
  end

  def self.authz_url
    @@authz_url
  end

  def self.authn_exp
    @@authn_exp
  end

  def self.authz_exp
    @@authz_exp
  end
end
