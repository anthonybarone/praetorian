$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "praetorian/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "praetorian"
  s.version     = Praetorian::VERSION
  s.authors     = ["Anthony Barone"]
  s.email       = ["barone42@gmail.com"]
  s.homepage    = "https://github.com/anthonybarone"
  s.summary     = "User Management System."
  s.description = "Praetorian makes duplicating user management features a breeze for any rails application.  It includes a restful user model to authenticate against, remember user, reset password and authorization permissions for controller actions and model attributes."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
# update s.test_files to accomodate rspec if necessary
  s.test_files = Dir["test/**/*"]

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
  s.add_dependency 'rails', '~> 4.1.0.rc1'
  
  # Use ActiveModel has_secure_password
  s.add_dependency 'bcrypt', '~> 3.1.2'

# Use SCSS for stylesheets
  s.add_dependency 'sass-rails', '~> 4.0.0.rc2'

# Use jquery-rails  
  s.add_dependency 'jquery-rails', '~> 3.0.1'

  # Use Uglifier as compressor for JavaScript assets
  s.add_dependency 'uglifier', '>= 1.3.0'

  # Use CoffeeScript for .js.coffee assets and views
  s.add_dependency 'coffee-rails', '~> 4.0.0'

  s.add_development_dependency 'sqlite3'
end