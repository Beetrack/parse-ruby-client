# Load credentials system
require_relative '../../lib/credentials'

# Make credentials available as Rails.application.credentials for compatibility
module Rails
  class Application
    def credentials
      @credentials ||= begin
        creds = Credentials::Manager.new(Rails.env)
        # Create a simple object that responds to method_missing for credential access
        Object.new.tap do |obj|
          def obj.method_missing(method, *args)
            Credentials.get(method.to_s, Rails.env)
          end
          
          def obj.respond_to_missing?(method, include_private = false)
            Credentials.all(Rails.env).key?(method.to_s)
          end
        end
      end
    end
  end
end
