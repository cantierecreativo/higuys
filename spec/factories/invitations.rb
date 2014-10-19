FactoryGirl.define do
  factory :invitation do
    account
    sequence(:email) { |i| "email-#{i}@foo.it" }
    sequence(:invitation_code) { |i| "code-#{i}" }
  end
end

