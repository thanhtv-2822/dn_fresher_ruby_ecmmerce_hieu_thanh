require "jwt"

class Auth
  ALGORITHM = "HS256".freeze

  class << self
    def encode payload
      payload[:exp] = 24.hours.from_now.to_i
      JWT.encode(payload, ENV["AUTH_SECRET"], ALGORITHM)
    end

    def decode token
      JWT.decode(token, ENV["AUTH_SECRET"], true, algorithm: ALGORITHM).first
    end
  end
end
