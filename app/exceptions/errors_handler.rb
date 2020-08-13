module ErrorsHandler
  module Handler
    def self.included(clazz)
      clazz.class_eval do
        rescue_from ActiveRecord::RecordNotFound, with: :json_not_found_message
      end
    end

    protected

    def json_not_found_message(exception)
      render json: {
        error: {
          message: (I18n.t(exception.model, scope: 'models').presence || '') + I18n.t('errors.messages.not_found')
        }
      }, status: :not_found
    end

    def json_validation_error(resource, message = nil)
      {
        json: {
          error: {
            code: 422,
            message: message.presence || 'Ocorreu um erro.',
            errors: resource.try(:errors).presence || resource
          }
        },
        status: :unprocessable_entity
      }
    end

    def json_destroy_error(message)
      {
        json: {
          error: {
            code: 422,
            message: message.presence || 'Ocorreu um erro.'
          }
        },
        status: :unprocessable_entity
      }
    end
  end
end