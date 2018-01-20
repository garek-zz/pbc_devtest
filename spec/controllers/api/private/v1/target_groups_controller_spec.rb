require 'rails_helper'

RSpec.describe Api::Private::V1::TargetGroupsController, type: :controller do
  describe 'GET list' do
    context 'when token is valid' do
      let(:country) { create(:country_with_target_groups) }
      let(:token) { create(:api_client).client_key }
      let(:target_group_keys) { ['id', 'name', 'external_id', 'parent_id', 'secret_code', 'panel_provider_id'] }

      before { create(:country_with_target_groups) } # fake country

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
          expect(JSON.load(response.body).first.keys).to match_array(target_group_keys)
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

  describe 'POST evaluate_target' do
    context 'when token is valid' do
      let(:price) { 100 }
      let(:token) { create(:api_client).client_key }
      let(:params) do 
        { country_code: Faker::Number.number(10),
          target_group_id: Faker::Number.number(10),
          locations: [{id: Faker::Number.number(10), panel_size: 200}]
        }
      end

      context 'and params are valid' do
        before :each do
          allow_any_instance_of(TargetEvaluation).to receive(:valid?).and_return(true)
          allow_any_instance_of(TargetEvaluation).to receive(:evaluate).and_return(price)

          @request.headers['Authorization'] = "Token #{token}"
          post :evaluate_target, params
        end

        it 'returns status 200' do
          expect(response.status).to eq(200)
        end

        it 'returns correct content-type' do
          expect(response.header['Content-Type']).to match('application/json')
        end

        it 'returns data with correct keys' do
          expect(JSON.load(response.body)['price']).to eq(price)
        end
      end

      context 'and params are invalid' do
        let(:errors) { {'country_code' => 'Country not found'} }
        before :each do
          allow_any_instance_of(TargetEvaluation).to receive(:valid?).and_return(false)
          allow_any_instance_of(TargetEvaluation).to receive(:errors).and_return(errors)

          @request.headers['Authorization'] = "Token #{token}"
          get :evaluate_target, params
        end

        it 'returns status 422' do
          expect(response.status).to eq(422)
        end

        it 'returns correct content-type' do
          expect(response.header['Content-Type']).to match('application/json')
        end

        it 'returns an error' do
          expect(JSON.load(response.body)['errors']).to eq(errors)
        end
      end     

      context 'and param is missing' do
        let(:params) { { country_code: Faker::Number.number(10) } }

        before :each do
          @request.headers['Authorization'] = "Token #{token}"
          get :evaluate_target, params
        end

        it 'returns status 400' do
          expect(response.status).to eq(400)
        end

        it 'returns correct content-type' do
          expect(response.header['Content-Type']).to match('application/json')
        end

        it 'returns an error' do
          expect(JSON.load(response.body)['error']).to eq('param is missing or the value is empty: target_group_id')
        end
      end

      context 'when connection failed to external service' do
        let(:exception_message) { 'some exception' }
        before :each do
          allow_any_instance_of(TargetEvaluation).to receive(:valid?).and_return(true)
          allow_any_instance_of(TargetEvaluation).to receive(:evaluate).and_raise(PriceLogic::ConnectionError.new(exception_message))

          @request.headers['Authorization'] = "Token #{token}"
          post :evaluate_target, params
        end

        it 'returns status 500' do
          expect(response.status).to eq(500)
        end

        it 'returns correct content-type' do
          expect(response.header['Content-Type']).to match('application/json')
        end

        it 'returns data with correct keys' do
          expect(JSON.load(response.body)['error']).to eq(exception_message)
        end
      end
    end

    context 'when token is invalid' do
      let(:fake_token) { 'fake_token' + Faker::Code.asin }
      let(:country) { create(:country) }

      before do
        @request.headers['Authorization'] = "Token #{fake_token}"
        get :evaluate_target, country_code: country.country_code
      end

      it 'returns 401 status' do
        expect(response.status).to eq(401)
      end
    end
  end
end
