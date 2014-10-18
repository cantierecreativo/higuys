FactoryGirl.define do
  factory :wall do
    sequence(:access_code) { |i| "access-#{i}" }
  end
end

