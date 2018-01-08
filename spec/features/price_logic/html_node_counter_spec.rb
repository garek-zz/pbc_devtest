require 'spec_helper'

RSpec.describe PriceLogic::Counter::HTMLNodeCounter, type: :class, vcr: true do
  context '#get_price' do
    context 'when request status is success' do
      subject { PriceLogic::Counter::HTMLNodeCounter }

      it 'returns correct value' do
        VCR.use_cassette('html_node_counter_response') do
          expect(subject.get_price).to eq(36)
        end
      end
    end
  end
end
