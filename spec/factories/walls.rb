FactoryGirl.define do
  factory :wall do
    sequence(:access_code) { |i| "access-#{i}" }

    trait :with_account do
      account
    end
  end
end

