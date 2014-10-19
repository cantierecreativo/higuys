FactoryGirl.define do
  factory :user do
    trait :with_wall do
      wall
    end
  end

  factory :guest, class: Guest, parent: :user do
    type "Guest"
  end

  factory :registered_user, class: RegisteredUser, parent: :user do
    type "RegisteredUser"
  end
end

