require 'rails_helper'

RSpec.describe TargetGroup, type: :model do
  describe 'root?' do
    context 'when target_group is root' do
      subject { build(:target_group_root) }

      it 'returns true' do
        expect(subject.root?).to eq(true)
      end
    end

    context 'when target_group is leaf' do
      subject { build(:target_group_leaf) }

      it 'returns false' do
        expect(subject.root?).to eq(false)
      end
    end
  end

  describe '#save' do
    context 'when target_group has countries' do
      context 'and parent_id is not nil' do
        before do
          @root1 = create(:target_group_with_countries)
          @root2 = create(:target_group_root)
          @root1.parent = @root2
        end

        it 'returns an error' do
          expect(@root1.valid?).to eq(false)
        end
      end
    end
  end
end
