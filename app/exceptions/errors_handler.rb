module ErrorsHandler
  module Handler
    def self.included(clazz)
      clazz.class_eval do
        rescue_from ActiveRecord::RecordNotFound, with: :json_not_found_message
        rescue_from ActiveRecord::RecordInvalid, with: :json_record_not_valid
        rescue_from CustomException, with: :json_custom_error
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

    def json_record_not_valid(exception)
      render json: {
        error: {
          message: I18n.t('errors.messages.fail_on_save') + (I18n.t(exception.record.model_name, scope: 'models').try(:strip).presence || ''),
          errors: exception.record.try(:errors).presence || ''
        }
      }, status: :unprocessable_entity
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

    def json_custom_error(exception)
      render json: {
        error: {
          code: 422,
          message: exception.message
        }
      }, status: :unprocessable_entity
    end

    def json_error(message)
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
