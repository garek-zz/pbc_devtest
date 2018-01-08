require 'spec_helper'

RSpec.describe PriceLogic::Counter::CharacterCounter, type: :class, vcr: true do
  context '#get_price' do
    context 'when request status is success' do
      subject { PriceLogic::Counter::CharacterCounter }

      it 'returns correct value' do
        VCR.use_cassette('character_counter_response') do
          expect(subject.get_price).to eq(53)
        end
      end
    end
  end
end
