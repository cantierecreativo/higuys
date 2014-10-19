class AccountPage < Page
  set_url '/accounts{/account_id}'

  element :wall, '.wall'
  action :leave
end

