class Rack::Attack
  throttle('req/ip', limit: 120, period: 60.seconds) do |req|
    req.ip if req.path == "/api/upload-requests" && req.post?
  end
end

Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new
