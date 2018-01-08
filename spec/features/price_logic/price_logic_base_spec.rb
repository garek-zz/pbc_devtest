require 'spec_helper'
require_relative '../../../lib/price_logic/price_logic_base.rb'

RSpec.describe PriceLogic::PriceLogicBase, type: :class do
  describe '#request' do
    context 'when request status is success' do
      subject { PriceLogic::PriceLogicBase }
      let(:url) { 'http://www.example.net' }
      let(:body) { 'body for http://www.example.net' }

      before do
        stub_request(:any, url).to_return(body: body, status: 200, headers: { 'Content-Length' => body.size })
      end

      it 'returns response body' do
        expect(subject.send(:request, url)).to eq(body)
      end
    end

    context 'when request status is failure' do
      subject { PriceLogic::PriceLogicBase }
      let(:url) { 'http://www.example.net' }

      before do
        stub_request(:any, url).to_return(body: "", status: 401, headers: { 'Content-Length' => 0 })
      end

      it 'rasies the PriceLogic::ConnectionException' do
        expect { subject.send(:request, url) }.to raise_error(PriceLogic::ConnectionException)
      end
    end

    context 'when request raises connection error' do
      subject { PriceLogic::PriceLogicBase }
      let(:url) { 'http://www.example.net' }

      before do
        stub_request(:any, url).to_raise(Timeout::Error)
      end

      it 'raises the PriceLogic::ConnectionException' do
        expect { subject.send(:request, url) }.to raise_error(PriceLogic::ConnectionException)
      end
    end
  end
end
