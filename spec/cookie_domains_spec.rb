require File.join(File.dirname(__FILE__), "spec_helper")
require File.join(File.dirname(__FILE__), "..", "lib", "cookie_domains")

describe CookieDomains do

  describe "#domain_for_host" do
    before do
      @cookie_domains = CookieDomains.new(mock('app'), ".example.com")
    end
  
    it "should recognize subdomains" do
      @cookie_domains.domain_for_host("www.example.com").should == ".example.com"
      @cookie_domains.domain_for_host("more.subdomains.example.com").should == ".example.com"
    end
    
    it "should recognize default domain" do
      @cookie_domains.domain_for_host("example.com").should == ".example.com"
    end
    
    it "should return given hostname starting with dot for hosts other than default domains" do
      @cookie_domains.domain_for_host("www.example.org").should == ".www.example.org"
      @cookie_domains.domain_for_host("example.net").should == ".example.net"
    end
  end

  describe "with no default domains" do
    
    it "should set hostname starting with dot as cookie domain" do
      env = Rack::MockRequest.env_for("http://www.example.com/", :method => :get)
      app = mock('app')
      app.should_receive(:call) { |resp|
        resp['rack.session.options'][:domain].should == ".www.example.com"
        ActionController::Base.session_options[:session_domain].should == ".www.example.com"
        ActionController::Base.session_options[:domain].should == ".www.example.com"
      }
      response = CookieDomains.new(app).call(env)
    end
  end

  describe "with some default domains" do
    
    it "should recognize subdomain of default domain" do
      env = Rack::MockRequest.env_for("http://www.example.com/", :method => :get)
      app = mock('app')
      app.should_receive(:call) { |resp|
        resp['rack.session.options'][:domain].should == ".example.com"
        ActionController::Base.session_options[:session_domain].should == ".example.com"
        ActionController::Base.session_options[:domain].should == ".example.com"
      }
      response = CookieDomains.new(app, ".example.com").call(env)
    end

    it "should recognize default domain" do
      env = Rack::MockRequest.env_for("http://example.com/", :method => :get)
      app = mock('app')
      app.should_receive(:call) { |resp|
        resp['rack.session.options'][:domain].should == ".example.com"
        ActionController::Base.session_options[:session_domain].should == ".example.com"
        ActionController::Base.session_options[:domain].should == ".example.com"
      }
      response = CookieDomains.new(app, ".example.com").call(env)
    end

    it "should work with other than default domain" do
      env = Rack::MockRequest.env_for("http://www.example.org/", :method => :get)
      app = mock('app')
      app.should_receive(:call) { |resp|
        resp['rack.session.options'][:domain].should == ".www.example.org"
        ActionController::Base.session_options[:session_domain].should == ".www.example.org"
        ActionController::Base.session_options[:domain].should == ".www.example.org"
      }
      response = CookieDomains.new(app).call(env)
    end
  end
end
