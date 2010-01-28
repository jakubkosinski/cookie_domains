require 'action_controller'

class CookieDomains
  def initialize(app, *default_domains)
    @app = app
    @default_domains = default_domains
  end
 
  def call(env)
    host = env['SERVER_NAME']
    host = env["HTTP_HOST"].split(':').first if env["HTTP_HOST"]
    domain = domain_for_host(host)
    env["rack.session.options"] ||= {}
    env["rack.session.options"][:domain] = domain
    ActionController::Base.session_options.update(:session_domain => domain, :domain => domain)
    @app.call(env)
  end
 
  def domain_for_host(host)
    @default_domains.detect do |domain|
      domain = domain.sub(/^\./, '')
      host =~ /#{domain}$/i
    end || ".#{host}"
  end
end
