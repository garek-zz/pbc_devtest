class Api::Private::ApiController < ActionController::Base
  before_action :authenticate_api_client

  rescue_from ActionController::ParameterMissing, with: :missing_parameter_error

  private

  def authenticate_api_client
    authenticate_or_request_with_http_token do |token, options|
      ApiClient.exists?(client_key: token)
    end
  end

  def missing_parameter_error(exception)
    render :json => {error: exception.message}, :status => 400
  end
end
