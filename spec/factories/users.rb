FactoryGirl.define do
  factory :user do
    status_message "a status message"
    trait :with_wall do
      wall
    end
  end

  factory :guest, class: Guest, parent: :user do
    type "Guest"
  end

  factory :registered_user, class: RegisteredUser, parent: :user do
    type "RegisteredUser"
    sequence(:github_user_id) { "XXX" }
    email "foo@bar.it"

    trait :with_account do
      association :wall, factory: [:wall, :with_account]
    end
  end
end

