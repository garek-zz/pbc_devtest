require 'spec_helper'

RSpec.describe PriceLogic::Counter::ArrayCounter, type: :class, vcr: true do
  context '#get_price' do
    context 'when request status is success' do
      subject { PriceLogic::Counter::ArrayCounter }

      it 'returns correct value' do
        VCR.use_cassette('array_counter_response') do
          expect(subject.get_price).to eq(88)
        end
      end
    end
  end
end
