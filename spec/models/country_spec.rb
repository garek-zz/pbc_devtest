require 'rails_helper'

RSpec.describe Country, type: :model do
  describe '#check_target_group_root?' do
    context 'when target_group is root' do
      let(:target_group_root) { create(:target_group_root) }
      let(:country) { build(:country) }

      it 'returns nil valie' do
        expect(country.send(:check_target_group_root?, target_group_root)).to be_nil
      end
    end

    context 'when target_group is leaf' do
      let(:target_group_leaf) { create(:target_group_leaf) }
      let(:country) { build(:country) }

      it 'raises an error' do
        expect { country.send(:check_target_group_root?, target_group_leaf) }.to raise_error(ActiveRecord::Rollback)
      end
    end
  end

  describe 'creating' do
    context 'when country_code is blank' do
      subject { build(:country, country_code: nil) }

      it 'returns false for valid' do
        expect(subject).to_not be_valid
      end
    end

    context 'when country_code is not blank' do
      let(:country_code) { Faker::Lorem.word }
      subject { build(:country, country_code: country_code) }

      it 'returns true for valid' do
        expect(subject).to be_valid
      end
    end

    context 'when country_code exists' do
      let(:country) { create(:country) }
      subject { build(:country, country_code: country.country_code) }

      it 'returns false for valid' do
        expect(subject).to_not be_valid
      end
    end

    context 'when target_group is leaf' do
      let(:target_group_leaf) { create(:target_group_leaf) }
      let(:country) { build(:country, target_groups: [create(:target_group_leaf)]) }

      it 'raises an error' do
        expect { country.save }.to raise_error(ActiveRecord::Rollback)
      end
    end
  end
end
