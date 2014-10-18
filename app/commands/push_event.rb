class PushEvent < Struct.new(:wall, :event, :data)
  extend Command

  def execute
    Pusher.trigger(channel_name, event, data)
  end

  private

  def channel_name
    @channel_name ||= "demo-#{wall.access_code}"
  end
end
