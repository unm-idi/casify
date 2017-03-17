module Casify::AuthController

  extend ActiveSupport::Concern

  included do
    before_action :set_request_uri, except: :auth_callback
    before_action :auth_user, except: :auth_callback
    before_action :set_current_user, except: [:auth_callback, :auth_user]
  end

  def auth_callback
    session['user'] = cas_auth_hash
    session['auth_expiration'] = Time.now + Casify.auth_exp
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
    {
      'username' => creds['uid'],
      'roles' => JSON.parse(creds['extra']['user_roles']),
      'extra_attributes' => {
        'email' => creds['info']['email']
      }
    }
  end

  def set_current_user
    @current_user = Casify::User.new(session['user'])
  end

  def auth_n_fresh?
    check_freshness session['auth_expiration']
  end

  def check_freshness(exp_time)
    if (exp = exp_time.to_s.to_time)
      Time.now < exp
    else
      false
    end
  end
end
