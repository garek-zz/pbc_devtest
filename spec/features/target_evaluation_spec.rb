require 'rails_helper'

RSpec.describe TargetEvaluation, type: :class do
  describe '#evaluate' do
    context 'when data is valid' do
      let(:country) { create(:country) }
      let(:target_group) { create(:target_group) }
      let(:location) { create(:location) }
      let(:price) { 100 }

      subject { TargetEvaluation.new(country.country_code, target_group.id, [{id: location.id, panel_size: 123}]) }

      before { allow_any_instance_of(PanelProvider).to receive(:price).and_return(price) }

      it 'returns correct price' do
        expect(subject.evaluate).to eq(price)
      end
    end

    context 'when data is invalid' do
      subject { TargetEvaluation.new(nil, nil, []) }

      it 'returns nil value' do
        expect(subject.evaluate).to eq(nil)
      end
    end
  end

  describe '#valid?' do
    context 'when data is valid then' do
      let(:country) { create(:country) }
      let(:target_group) { create(:target_group) }
      let(:location) { create(:location) }

      subject { TargetEvaluation.new(country.country_code, target_group.id, [{id: location.id, panel_size: 123}]) }

      it 'returns true' do
        expect(subject.valid?).to eq(true)
      end

      it 'errors hash is empty' do
        expect(subject.errors).to be_empty
        subject.valid?
        expect(subject.errors).to be_empty
      end
    end

    context 'when data is invalid' do
      subject { TargetEvaluation.new(nil, nil, []) }

      it 'returns false' do
        expect(subject.valid?).to eq(false)
      end

      it 'errors hash is not empty' do
        expect(subject.errors).to be_empty
        subject.valid?
        expect(subject.errors).to_not be_empty
      end
    end
  end

  describe '#validate_country_code' do
    context 'when target_group exists' do
      let(:country) { create(:country) }
      subject { TargetEvaluation.new(country.country_code, nil, []) }

      it 'returns nil' do
        expect(subject.errors).to be_empty
        expect(subject.send(:validate_country_code)).to be_nil
      end

      it 'does not change errors hash' do
        expect(subject.errors).to be_empty
        subject.send(:validate_country_code)
        expect(subject.errors).to be_empty
      end
    end

    context 'when location does not exist' do
      subject { TargetEvaluation.new(nil, Faker::Number.number(10), []) }

      it 'adds an error' do
        expect(subject.errors).to be_empty
        subject.send(:validate_country_code)
        expect(subject.errors).to match({country_code: 'Country not found'})
      end
    end
  end

  describe '#validate_target_group_id' do
    context 'when target_group exists' do
      let(:target_group) { create(:target_group) }
      subject { TargetEvaluation.new(nil, target_group.id, []) }

      it 'returns nil' do
        expect(subject.errors).to be_empty
        expect(subject.send(:validate_target_group_id)).to be_nil
      end

      it 'does not change errors hash' do
        expect(subject.errors).to be_empty
        subject.send(:validate_target_group_id)
        expect(subject.errors).to be_empty
      end
    end

    context 'when location does not exist' do
      subject { TargetEvaluation.new(nil, Faker::Number.number(10), []) }

      it 'adds an error' do
        expect(subject.errors).to be_empty
        subject.send(:validate_target_group_id)
        expect(subject.errors).to match({target_group_id: 'TargetGroup not found'})
      end
    end
  end

  describe '#validate_locations' do
    context 'when location exists' do
      let(:location) { create(:location) }
      subject { TargetEvaluation.new(nil, nil, [{id: location.id}]) }

      it 'returns nil' do
        expect(subject.errors).to be_empty
        expect(subject.send(:validate_locations)).to be_nil
      end

      it 'does not change errors hash' do
        expect(subject.errors).to be_empty
        subject.send(:validate_locations)
        expect(subject.errors).to be_empty
      end
    end

    context 'when location does not exist' do
      subject { TargetEvaluation.new(nil, nil, [{id: Faker::Number.number(10)}]) }

      it 'adds an error' do
        expect(subject.errors).to be_empty
        subject.send(:validate_locations)
        expect(subject.errors).to match({locations: 'Location not found'})
      end
    end
  end
end
