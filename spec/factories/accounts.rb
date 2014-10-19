FactoryGirl.define do
  factory :account do
    name "Cantiere Creativo"
    sequence(:slug) { |i| "foo-#{i}" }
    wall
  end
end

