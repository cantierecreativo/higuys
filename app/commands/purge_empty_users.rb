class PurgeEmptyUsers < Struct.new(:since)
  extend Command

  def execute
    User.without_images.where("created_at < ?", since.ago).destroy_all.size
  end
end
