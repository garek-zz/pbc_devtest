require 'rails_helper'

RSpec.describe PanelProvider, type: :model do
  describe 'creating' do
    context 'when code is blank' do
      subject { build(:panel_provider, code: nil) }

      it 'returns false for valid' do
        expect(subject).to_not be_valid
      end
    end

    context 'when code is not blank' do
      subject { build(:panel_provider) }

      it 'returns true for valid' do
        expect(subject).to be_valid
      end
    end

    context 'when PanelProvider::PRICE_TYPES does not include price_type' do
      subject { build(:panel_provider_with_fake_price_type) }

      it 'returns false for valid' do
        expect(subject).to_not be_valid
      end
    end

    context 'when price_type is empty' do
      subject { build(:panel_provider_with_empty_price_type) }

      it 'returns false for valid' do
        expect(subject).to_not be_valid
      end      
    end

    context 'when price_type is kind of PanelProvider::PRICE_TYPES' do
      subject { build(:panel_provider) }

      it 'returns true for valid' do
        expect(subject).to be_valid
      end
    end
  end

  describe '#price' do
    subject { build(:panel_provider) }
    let(:price_type_class) { PanelProvider::PRICE_TYPES[subject.price_type] }
    let(:price) { 100 }

    before do
      allow(price_type_class).to receive(:get_price) { price }
    end

    it 'returns correct price' do
      expect(subject.price).to eq(price)
    end
  end
end
