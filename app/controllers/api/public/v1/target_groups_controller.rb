class Api::Public::V1::TargetGroupsController < ActionController::Base
  include Api::Concerns::V1::TargetGroups

  def list
    if @country
      render json: @target_groups.to_json(only: :name)
    else
      render json: { error: 'Country not found' }, status: 422
    end
  end
end
