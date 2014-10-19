require 'rails_helper'

RSpec.describe User, type: :model do

  it { is_expected.to validate_presence_of(:secret_token) }
  it {
    create(:guest)
    is_expected.to validate_uniqueness_of(:secret_token)
  }

  describe '.by_id' do
    let(:user1) { create(:guest) }
    let(:user2) { create(:guest) }

    before do
      user1
      user2
    end

    it 'returns the user ordere by id in ascending order' do
      expect(User.by_id).to eq([user1, user2])
    end
  end

  describe '.active_in_the_last' do
    let(:user) { create(:guest) }
    let(:image) { create(:image, user: user, image_path: 'foobar.jpg') }

    context 'if the user was active less than 5 minutes ago' do
      before do
        image.created_at = 3.minutes.ago
        user.last_image = image
        image.save
        user.save
      end

      it 'is returned' do
        expect(User.active_in_the_last(5.minutes)).to eq([user])
      end
    end

    context 'else' do
      before do
        image.created_at = 10.minutes.ago
        user.last_image = image
        image.save
        user.save
      end

      it 'is not returned' do
        expect(User.active_in_the_last(5.minutes)).to eq([])
      end
    end
  end
end

