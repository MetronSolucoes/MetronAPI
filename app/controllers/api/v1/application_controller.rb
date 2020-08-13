class Api::V1::ApplicationController < ActionController::API
  include ErrorsHandler::Handler
  include ActionController::Serialization
  include ActionController::HttpAuthentication::Basic::ControllerMethods

  protect_from_forgery with: :null_session

  def json_destroy_success(message)
    {
      json: {
        message: message
      },
      status: :ok
    }
  end
end
