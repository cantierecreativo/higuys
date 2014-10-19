json.array! @guests do |guest|
  json.id guest.id
  json.image_url guest.last_image.try(:imgx_url)
  json.active_at guest.last_image.try(:created_at)
end

