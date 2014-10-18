class WallPage < Page
  set_url '/walls{/id}'

  element :wall, '.wall'
  action :leave
end

