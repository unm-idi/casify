module Casify::AuthController
  AUTHZ_URL = ENV['authz_url'].to_s
  AUTH_N_EXP = (ENV['auth_n_exp'] || 3).to_i.seconds
  AUTH_Z_EXP = (ENV['auth_z_exp'] || 180).to_i.seconds

  extend ActiveSupport::Concern

  included do
    before_action :set_request_uri, except: :auth_callback
    before_action :auth_user, except: :auth_callback
    before_action :set_current_user, except: [:auth_callback, :auth_user]
  end

  def auth_callback
    session['user'] = cas_auth_hash
    session['user']['roles'] = get_user_roles
    session['authn_expiration'] = Time.now + AUTH_N_EXP
    redirect_to session['request_uri']
  end

  private

  def set_request_uri
    session['request_uri'] = request.try(:env).try(:fetch, 'REQUEST_URI') || '/'
  end

  def auth_user
    unless auth_n_fresh?
      redirect_to '/auth/cas'
    end
  end

  def cas_auth_hash
    creds = Marshal.load Marshal.dump(request.env['omniauth.auth'])
    {'username' => creds['uid'], 'extra_attributes' => creds['info'].merge(creds['extra'])}
  end

  def get_user_roles
    if session['user']['roles'].nil? || !auth_z_fresh?
      HTTParty.get(AUTHZ_URL, query: {username: session['user']['username']})['roles']
      session['authz_expiration'] = Time.now + AUTH_Z_EXP
    else
      session['user']['roles']
    end
  end

  def set_current_user
    @current_user = Casify::User.new(session['user'])
  end

  def auth_z_fresh?
    check_freshness
  end

  def auth_n_fresh?
    check_freshness session['authn_expiration']
  end

  def check_freshness(exp_time)
    if (exp = exp_time.to_s.to_time)
      Time.now < exp
    else
      false
    end
  end
end
