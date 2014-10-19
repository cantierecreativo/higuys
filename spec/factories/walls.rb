FactoryGirl.define do
  factory :wall do
    sequence(:access_code) { |i| "access-#{i}" }

    trait :with_account do
      account
      access_code ''
    end
  end
end

