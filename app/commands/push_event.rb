class PushEvent < Struct.new(:wall, :event, :data)
  extend Command

  def self.channel_name(wall)
    @channel_name = if wall.account
                        "account-#{wall.account.slug}"
                      else
                        "demo-#{wall.access_code}"
                      end
  end

  def execute
    Pusher.trigger(self.class.channel_name(wall), event, data)
  end
end

