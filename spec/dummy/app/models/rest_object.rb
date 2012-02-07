class RestObject < ActiveResource::Base

  is_used_permissively :active_resource => true
  self.site = "http://api.sample.com"

  self.format = :xml

end
