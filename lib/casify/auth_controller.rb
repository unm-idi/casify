module Casify::AuthController

  extend ActiveSupport::Concern

  included do
    before_action :set_request_uri, except: :auth_callback
    before_action :auth_user, except: :auth_callback
    before_action :set_current_user, except: [:auth_callback, :auth_user]
  end

  def auth_callback
    session['user'] = cas_auth_hash
    session['auth_expiration'] = Time.now + 1.hours
    session['hard_auth_exp'] ||= Time.now + 8.hours
    redirect_to session['request_uri']
  end

  def logout
    reset_session
    redirect_to "//#{Casify.configuration.cas_url}/logout"
  end

  private

  def set_request_uri
    session['request_uri'] = request.try(:env).try(:fetch, 'REQUEST_URI') || '/'
  end

  def auth_user

    unless auth_n_fresh?
      session['hard_auth_exp'] = nil
      redirect_to '/auth/cas'
    end
    session['auth_expiration'] = Time.now + 1.hours
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
    session['auth_expiration'] ||= Time.now - 1.hours
    session['hard_auth_exp'] ||= Time.now - 8.hours
    Time.now < session['auth_expiration'].to_time && Time.now < session['hard_auth_exp'].to_time
  end

end
