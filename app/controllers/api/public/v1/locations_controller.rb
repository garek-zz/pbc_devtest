class Api::Public::V1::LocationsController < ActionController::Base
  include Api::Concerns::V1::Locations

  def list
    if @country
      render json: @locations.to_json(only: :name)
    else
      render json: { error: 'Country not found' }, status: 422
    end
  end
end
