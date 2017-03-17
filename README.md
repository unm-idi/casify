# Casify


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'casify', git: 'git@github.com:unm-idi/casify.git'
```

And then execute:

    $ bundle


## Usage

Casify is intended to provide a single sign on (SSO) authentication/authorization solution for client applications developed by [UNM IDI](http://idi.unm.edu).

In order to communicate with a CAS server omniauth-cas is used. Right now, the setup of this gem must be done by the user. Setup is straightforward, and consists of creating an initializer in order to accomplish this. Consult the [OmniAuth Cas Github](https://github.com/dlindahl/omniauth-cas) page for examples of options that can be used.

In order to limit the amount of traffic sent between client applications and the described CAS server, an authentication timeout can be set. The authentication timeout describes how long before the application will check the user's CAS ticket with the described CAS server. As long as the CAS ticket is still valid, this process will be transparent to the user.

Initializing the Casify gem can be done by creating an initializer at `/config/initializers/casify.rb`. An example initialization using a 3 minute timeout is shown in the block below.

```ruby
Casify.configure(
  auth_exp: 180
)
```

The default timeout is set to 3 seconds. This will ensure that the CAS ticket is checked with every user request. No persistent data store is assumed, and user information is stored in the session cookie. Rails will encrypt this cookie by default, and the user will not be able to view or augment any information it contains. However, if the expiration time is extended it is **HIGHLY** recommended that communication between the client application and the user be encrypted (HTTPS, TLS). This ensures that the cookie can not be hijacked and used by an attacker to masquerade as a logged in user.

In order to authenticate/authenticate users, two things need to be done. First, add the following line of code to your Application Controller, this will add the proper before actions.

```ruby
class ApplicationController < ActionController::Base
  include Casify::AuthController

  # The rest of your controller goes here...
```

Then, in your routes add this line to set up the CAS callback route. For more info on the callback url start [here](https://github.com/dlindahl/omniauth-cas).

```ruby
Rails.application.routes.draw do
  # Here are your routes...

  # Put this in for Casify
  get '/auth/:provider/callback', to: 'application#auth_callback'
```

If you wish to skip authentication for any routes, simply skip the before action that authenticates the user for that specific route in that specific controller

```ruby
class SomeController< ApplicationController
  skip_before_action :auth_user, only: :unauthed_route

  # Here is the rest of your controller...
```



## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/casify. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
