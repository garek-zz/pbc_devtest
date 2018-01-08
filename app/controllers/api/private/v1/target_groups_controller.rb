class Api::Private::V1::TargetGroupsController < Api::Private::ApiController
  include Api::Concerns::V1::TargetGroups

  before_filter :init_target_evaluation, only: [:evaluate_target]

  rescue_from PriceLogic::ConnectionException, with: :connection_error  

  def list
    if @country
      render json: @target_groups.to_json(only: [:id, :name, :external_id, :parent_id, :secret_code, :panel_provider_id])
    else
      render json: { error: 'Country not found' }, status: 422
    end
  end

  def evaluate_target
    if @target_evaluation.valid?
      render json: { price: @target_evaluation.evaluate }
    else
      render json: { errors: @target_evaluation.errors}, status: 422
    end
  end

  private

  def evaluate_params
    params.permit(:country_code, :target_group_id, locations: [:id, :panel_size]).tap do |params|
      params.require(:country_code)
      params.require(:target_group_id)
      params.require(:locations).each do |location|
        location.require(:id)
        location.require(:panel_size)
      end
    end
  end

  def init_target_evaluation
    country_code    = evaluate_params[:country_code]
    target_group_id = evaluate_params[:target_group_id]
    locations       = evaluate_params[:locations]

    @target_evaluation = TargetEvaluation.new(country_code, target_group_id, locations)
  end

  def connection_error(exception)
    render :json => {error: exception.message}, :status => 500
  end
end
