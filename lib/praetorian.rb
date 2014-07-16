# require any gems that are used in the rails engine here.

# require bcrypt-ruby', '~> 3.0.0' fails for some reason
# I changed my gem to gem 'bcrypt-ruby', '~> 3.1.0' which installed bcrypt 3.1.7. Saw a warning message about the gem being renamed and changed it to gem 'bcrypt', '~> 3.1.0' 
require "bcrypt"
require "sass-rails"
require "uglifier"
require "coffee-rails"
require "praetorian/engine"

module Praetorian
end
