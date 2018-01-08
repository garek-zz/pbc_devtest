require 'rails_helper'

RSpec.describe ApiClient, type: :model do
  describe '#generate_client_key' do
    let(:api_client) { ApiClient.create }
    subject { api_client.send(:generate_client_key) }
    
    it 'generates uniq client_key' do
      expect(ApiClient.find_by_client_key(subject).present?).to eq(false)
    end
  end

  describe 'init client_key' do
    subject { ApiClient.create }

    it 'has non blank client_key' do
      expect(subject.client_key).to_not eq(nil)
      expect(subject.client_key).to_not eq('')
    end
  end
end
