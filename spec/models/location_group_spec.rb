require 'rails_helper'

RSpec.describe LocationGroup, type: :model do
  describe 'creating' do
    context 'when name is blank' do
      subject { build(:location_group, name: nil) }

      it 'returns false for valid' do
        expect(subject).to_not be_valid
      end
    end

    context 'when name is not blank' do
      subject { build(:location_group) }

      it 'returns true for valid' do
        expect(subject).to be_valid
      end
    end
  end
end
