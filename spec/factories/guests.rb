FactoryGirl.define do
  factory :guest do
    trait :with_wall do
      wall
    end
  end
end

