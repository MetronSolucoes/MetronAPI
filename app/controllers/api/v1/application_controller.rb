class Api::V1::ApplicationController < ActionController::API
  include ErrorsHandler::Handler
  include ActionController::MimeResponds
  include ActionController::Serialization
  include ActionController::HttpAuthentication::Basic::ControllerMethods

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
