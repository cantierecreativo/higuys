class PushEvent < Struct.new(:wall, :event, :data)
  def self.execute(*args)
    new(*args).execute
  end

  def execute
    Pusher.trigger(channel_name, event, data)
  end

  private

  def channel_name
    @channel_name ||= "demo-#{wall.access_code}"
  end
end

