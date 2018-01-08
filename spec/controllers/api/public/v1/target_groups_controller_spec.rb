require 'rails_helper'

RSpec.describe Api::Public::V1::TargetGroupsController, type: :controller do
  describe 'GET list' do
    context 'when token is valid' do
      let(:country) { create(:country_with_target_groups) }

      before { create(:country_with_target_groups) } # fake country

      context 'and country_code exist' do
        before :each do
          get :list, country_code: country.country_code
        end

        it 'returns status 200' do
          expect(response.status).to eq(200)
        end

        it 'returns correct content-type' do
          expect(response.header['Content-Type']).to match('application/json')
        end

        it 'returns data with correct keys' do
          expect(JSON.load(response.body).first.keys).to match_array(['name'])
        end
      end

      context 'and country_code does not exist' do
        let(:fake_country_code) { 'fake_country_code' + Faker::Code.asin }

        before :each do
          get :list, country_code: fake_country_code
        end

        it 'returns status 422' do
          expect(response.status).to eq(422)
        end

        it 'returns correct content-type' do
          expect(response.header['Content-Type']).to match('application/json')
        end

        it 'returns an error' do
          expect(JSON.load(response.body)['error']).to eq('Country not found')
        end
      end
    end
  end
end
