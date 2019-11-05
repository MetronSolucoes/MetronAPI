require 'rails_helper'

RSpec.describe Api::V1::CustomersController, type: :controller do

  describe 'POST #create' do
    let(:formatted_response) { JSON.parse(response.body) }

    let(:params) { { customer: { name: 'Teste', last_name: 'Teste', cpf: '69431952041', phone: '1234567890', email: 'teste@teste.com' } } } #mock customer

    context 'when customer created with success' do
      before { post :create, params: params }

      it 'return customer and created status code' do
        expect(response).to have_http_status(:created)
        expect(formatted_response['name']).to eq(params[:customer][:name])
        expect(formatted_response['last_name']).to eq(params[:customer][:last_name])
        expect(formatted_response['cpf']).to eq(params[:customer][:cpf])
        expect(formatted_response['phone']).to eq(params[:customer][:phone])
        expect(formatted_response['email']).to eq(params[:customer][:email])
      end
    end

    context 'when creation fail' do
      context 'to save' do
        let(:invalid_params) { { customer: { name: nil } } }

        before do
          allow_any_instance_of(Customer).to receive(:save).and_return(false)
          post :create, params: invalid_params
        end

        it 'return unprocessable entity status code' do
          expect(response).to have_http_status(:unprocessable_entity)
          expect(formatted_response['message']).to eq('Falha ao criar cliente') #i18n
        end
      end

      context 'cpf and email invalid, name and last_name blank, phone too_short' do
        before do
          params[:customer][:name] = ''
          params[:customer][:last_name] = ''
          params[:customer][:cpf] = '1234444'
          params[:customer][:email] = 'abc'
          params[:customer][:phone] = '123'
          post :create, params: params
        end

        it 'return error invalid cpf and email, blank name and last_name, phone too short' do
          expect(response).to have_http_status(:unprocessable_entity)
          expect(formatted_response['errors']['cpf'].first).to eq(I18n.t('activerecord.errors.models.customer.attributes.cpf.invalid'))
          expect(formatted_response['errors']['name'].first).to eq(I18n.t('activerecord.errors.models.customer.attributes.name.blank'))
          expect(formatted_response['errors']['last_name'].first).to eq(I18n.t('activerecord.errors.models.customer.attributes.last_name.blank'))
          expect(formatted_response['errors']['email'].first).to eq(I18n.t('activerecord.errors.models.customer.attributes.email.invalid'))
          expect(formatted_response['errors']['phone'].first).to eq(I18n.t('activerecord.errors.models.customer.attributes.phone.too_short'))
        end
      end

      context 'phone, email and cpf taken' do
        let!(:customer) { create(:customer) }

        before { post :create, params: params }

        it 'return error phone, email and cpf taken' do
          expect(response).to have_http_status(:unprocessable_entity)
          expect(formatted_response['errors']['cpf'].first).to eq(I18n.t('activerecord.errors.models.customer.attributes.cpf.taken'))
          expect(formatted_response['errors']['email'].first).to eq(I18n.t('activerecord.errors.models.customer.attributes.email.taken'))
          expect(formatted_response['errors']['phone'].first).to eq(I18n.t('activerecord.errors.models.customer.attributes.phone.taken'))
        end
      end

      context 'phone too long' do
        before do
          params[:customer][:phone] = '1111111111111111111111111'
          post :create, params: params
        end

        it 'return error phone is too long' do
          expect(response).to have_http_status(:unprocessable_entity)          
          expect(formatted_response['errors']['phone'].first).to eq(I18n.t('activerecord.errors.models.customer.attributes.phone.too_long'))
        end
      end
    end
  end

  describe 'GET #show' do
    let(:formatted_response) { JSON.parse(response.body) }

    context 'when customer exists' do
      let(:customer) { create(:customer) }

      before { get :show, params: { id: customer.id } }

      it 'return status code ok' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when customer not found' do
      let(:not_found_code) { I18n.t('error_messages.customer_not_found.code') }
      let(:not_found_title) { I18n.t('error_messages.customer_not_found.title') }
      let(:not_found_detail) { I18n.t('error_messages.customer_not_found.detail') }

      before do
        get :show, params: { id: 'xpto' }
      end

      it 'return not found code, title and detail and status code not_found' do
        expect(response).to have_http_status(:not_found)
        expect(formatted_response['errors'].first['code']).to eq(not_found_code)
        expect(formatted_response['errors'].first['title']).to eq(not_found_title)
        expect(formatted_response['errors'].first['detail']).to eq(not_found_detail)
      end
    end
  end

  describe 'GET #index' do
    let(:formatted_response) { JSON.parse(response.body) }

    context 'when have customers to index' do
      let(:customer) { create(:customer) }

      before { get :index }

      it 'return ok status code, and customers array is not null' do
        expect(response).to have_http_status(:ok)
        expect(formatted_response).not_to be_nil
      end
    end
  end

  describe 'PUT #update' do
    let(:customer) { create(:customer) }
    let(:params) { { id: customer.id, customer: { name: 'Caio', last_name: 'Santos' } } }
    let(:formatted_response) { JSON.parse(response.body) }

    context 'when customer updated with success' do
      before { put :update, params: params }

      it 'return ok status code and updated customer' do
        expect(response).to have_http_status(:ok)
        expect(formatted_response['name']).to eq(params[:customer][:name])
        expect(formatted_response['last_name']).to eq(params[:customer][:last_name])
      end
    end

    context 'when updated fails' do
      before do
        allow_any_instance_of(Customer).to receive(:update_attributes).and_return(false)
        put :update, params: params
      end

      it 'return unprocessable_entity status code and fail message' do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(formatted_response['message']).to eq('Falha ao atualizar cliente')
      end
    end

    context 'when customer not exits' do
      let(:not_found_code) { I18n.t('error_messages.customer_not_found.code') }
      let(:not_found_title) { I18n.t('error_messages.customer_not_found.title') }
      let(:not_found_detail) { I18n.t('error_messages.customer_not_found.detail') }

      before { put :update, params: { id: '5684565' } }

      it 'return not_found status code and not found message' do
        expect(response).to have_http_status(:not_found)
        expect(formatted_response['errors'].first['code']).to eq(not_found_code)
        expect(formatted_response['errors'].first['title']).to eq(not_found_title)
        expect(formatted_response['errors'].first['detail']).to eq(not_found_detail)
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:customer) { create(:customer) }
    let(:formatted_response) { JSON.parse(response.body) }

    context 'when customer deleted with sucess' do
      before { delete :destroy, params: { id: customer.id } }

      it 'return no_content status code and success message' do
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'when customer not found' do
      let(:not_found_code) { I18n.t('error_messages.customer_not_found.code') }
      let(:not_found_title) { I18n.t('error_messages.customer_not_found.title') }
      let(:not_found_detail) { I18n.t('error_messages.customer_not_found.detail') }

      before { delete :destroy, params: { id: 'xpto' } }

      it 'return status code not_found and not found message' do
        expect(response).to have_http_status(:not_found)
        expect(formatted_response['errors'].first['code']).to eq(not_found_code)
        expect(formatted_response['errors'].first['title']).to eq(not_found_title)
        expect(formatted_response['errors'].first['detail']).to eq(not_found_detail)
      end
    end

    context 'when delete fails' do
      before do
        allow_any_instance_of(Customer).to receive(:destroy).and_return(false)
        delete :destroy, params: { id: customer.id }
      end

      it 'return unprocessable_entity status code and fail message' do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(formatted_response['message']).to eq('Falha ao deletar cliente')
      end
    end
  end
end