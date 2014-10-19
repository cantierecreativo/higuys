json.array! @users do |user|
  json.id user.id
  json.status_message user.status_message
  json.image_url user.last_image.try(:imgx_url)
  json.active_at user.last_image.try(:created_at)
end
