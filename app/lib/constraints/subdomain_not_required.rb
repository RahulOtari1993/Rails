module Constraints
  class SubdomainNotRequired
    def self.matches?(request)
      !request.subdomain.present?
    end
  end
end
