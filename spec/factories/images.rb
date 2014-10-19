FactoryGirl.define do
  factory :image do
    association :user, factory: :guest
    image_path "foo/bar/image.jpg"
  end
end

