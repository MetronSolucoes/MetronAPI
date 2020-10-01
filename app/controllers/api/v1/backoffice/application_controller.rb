class Api::V1::Backoffice::ApplicationController < ActionController::API
  include ErrorsHandler::Handler
  include ActionController::MimeResponds
  include ActionController::Serialization
  include ActionController::HttpAuthentication::Basic::ControllerMethods

  before_action :authenticate_user!

  def authenticate_user!
    decode_token
    set_current
  rescue
    not_authenticated
  end

  def decode_token
    request_token = request.headers['Authorization']
    @decripted_token ||= JsonToken.decode(request_token)
    @decripted_token
  end

  def set_current
    @current_user = User.find(@decripted_token[:user_id])
    raise if @current_user.token != @decripted_token[:user_token] || @decripted_token[:key] != JsonToken::PUBLIC_KEY
  end

  def not_authenticated
    render json: { error: I18n.t('errors.messages.not_authenticated') }, status: :unauthorized
  end

  def json_success(message)
    {
      json: {
        message: message
      },
      status: :ok
    }
  end

  def pagination(object)
    {
      current_page: object.current_page,
      per_page: object.per_page(params),
      total_pages: object.total_pages,
      total_count: object.total_count
    }
  end
end
