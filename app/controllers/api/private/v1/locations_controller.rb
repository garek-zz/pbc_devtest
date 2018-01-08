class Api::Private::V1::LocationsController < Api::Private::ApiController
  include Api::Concerns::V1::Locations

  def list
    if @country
      render json: @locations.to_json(only: [:id, :name, :external_id, :secret_code])
    else
      render json: { error: 'Country not found' }, status: 422
    end
  end
end
