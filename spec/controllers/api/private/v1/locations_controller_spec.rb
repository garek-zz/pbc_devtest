require 'rails_helper'

RSpec.describe Api::Private::V1::LocationsController, type: :controller do
  describe 'GET list' do
    context 'when token is valid' do
      let(:country) { create(:country_with_dependencies) }
      let(:token) { create(:api_client).client_key }

      before { create(:country_with_dependencies) } # fake country

      context 'and country_code exist' do
        before :each do
          @request.headers['Authorization'] = "Token #{token}"
          get :list, country_code: country.country_code
        end

        it 'returns status 200' do
          expect(response.status).to eq(200)
        end

        it 'returns correct content-type' do
          expect(response.header['Content-Type']).to match('application/json')
        end

        it 'returns data with correct keys' do
          expect(JSON.load(response.body).first.keys).to match_array(["id", "name", "external_id", "secret_code"])
        end
      end

      context 'and country_code does not exist' do
        let(:fake_country_code) { 'fake_country_code' + Faker::Code.asin }

        before :each do
          @request.headers['Authorization'] = "Token #{token}"
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

    context 'when token is invalid' do
      let(:fake_token) { 'fake_token' + Faker::Code.asin }
      let(:country) { create(:country) }

      before do
        @request.headers['Authorization'] = "Token #{fake_token}"
        get :list, country_code: country.country_code
      end

      it 'returns 401 status' do
        expect(response.status).to eq(401)
      end
    end
  end
end
