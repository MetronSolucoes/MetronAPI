require 'json_token'

class Api::V1::Backoffice::AuthenticationController < Api::V1::Backoffice::ApplicationController

  include ErrorsHandler::Handler

  skip_before_action :authenticate_user!

  def authenticate_user
    user = User.find_for_database_authentication(email: params[:email])
    if user&.valid_password?(params[:password])
      render json: response_user(user)
    else
      head :unauthorized
    end
  end

  def response_user(user)
    {
      auth_token: user_data_to_encode(user),
      user: {
        id: user.token,
        name: user.name,
        email: user.email,
        created_at: user.created_at.utc.to_i
      }
    }
  end

  def user_data_to_encode(user)
    JsonToken.encode(user_id: user.id, user_token: user.token, key: JsonToken::PUBLIC_KEY)
  end
end
