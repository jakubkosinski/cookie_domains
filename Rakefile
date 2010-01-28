require 'rake'
require 'spec'
require 'spec/rake/spectask'

desc 'Default: run unit tests.'
task :default => :spec
 
desc 'Test the cookie_domains plugin.'
Spec::Rake::SpecTask.new(:spec) do |t|
  t.libs << 'lib'
  t.verbose = true
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "cookie_domains"
    gem.summary = %Q{Rack middleware for setting cookies in Rails applications based on request host}
    gem.description = %Q{Cookie domains is a Rails plugin and Rack middleware to setting cookies in mutli-domain environment. Define domains for your applications and set correct cookie based on request hostname.}
    gem.email = "ja@ghandal.net"
    gem.homepage = "http://github.com/ghandal/cookie_domains"
    gem.authors = ["Jakub Kosiński"]
    gem.add_development_dependency "rspec", ">= 1.2.9"
    gem.add_development_dependency "action_controller", ">= 2.3"
  end
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

