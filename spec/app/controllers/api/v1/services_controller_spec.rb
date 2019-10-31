require 'rails_helper'

RSpec.describe Api::V1::ServicesController, type: :controller do

  describe 'POST #create' do
    let(:formatted_response) { JSON.parse(response.body) }

    context 'when service created with success' do
      let(:params) { { service: { name: 'Corte de Cabelo', description: 'Com Tesoura', duration: 1 } } } #ver se tem como mock service

      before { post :create, params: params }

      it 'return service and created status code' do
        expect(response).to have_http_status(:created)
        expect(formatted_response['name']).to eq(params[:service][:name])
        expect(formatted_response['description']).to eq(params[:service][:description])
        expect(formatted_response['duration']).to eq(params[:service][:duration])
      end
    end

    context 'when creation fail' do
      let(:invalid_params) { { service: { name: nil } } }

      before do
        allow_any_instance_of(Service).to receive(:save).and_return(false)
        post :create, params: invalid_params
      end

      it 'return unprocessable entity status code' do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(formatted_response['message']).to eq('Falha ao criar serviço') #i18n
      end
    end
  end

  describe 'GET #show' do
    let(:formatted_response) { JSON.parse(response.body) }

    context 'when service exists' do
      let(:service) { create(:service) }

      before { get :show, params: { id: service.id } }

      it 'return status code ok' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when service not found' do
      let(:not_found_code) { I18n.t('error_messages.service_not_found.code') }
      let(:not_found_title) { I18n.t('error_messages.service_not_found.title') }
      let(:not_found_detail) { I18n.t('error_messages.service_not_found.detail') }

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

    context 'when have services to index' do
      let(:service) { create(:service) }

      before { get :index }

      it 'return ok status code, and services array is not null' do
        expect(response).to have_http_status(:ok)
        expect(formatted_response).not_to be_nil
      end
    end
  end

  describe 'PUT #update' do
    let(:service) { create(:service) }
    let(:params) { { id: service.id, service: { name: 'Lavagem de cabelo', description: 'Com shampoo cheiroso' } } }
    let(:formatted_response) { JSON.parse(response.body) }

    context 'when service updated with success' do
      before { put :update, params: params }

      it 'return ok status code and updated service' do
        expect(response).to have_http_status(:ok)
        expect(formatted_response['name']).to eq(params[:service][:name])
        expect(formatted_response['description']).to eq(params[:service][:description])
      end
    end

    context 'when updated fails' do
      before do
        allow_any_instance_of(Service).to receive(:update_attributes).and_return(false)
        put :update, params: params
      end

      it 'return unprocessable_entity status code and fail message' do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(formatted_response['message']).to eq('Falha ao atualizar serviço')
      end
    end

    context 'when service not exits' do
      let(:not_found_code) { I18n.t('error_messages.service_not_found.code') }
      let(:not_found_title) { I18n.t('error_messages.service_not_found.title') }
      let(:not_found_detail) { I18n.t('error_messages.service_not_found.detail') }

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
    let(:service) { create(:service) }
    let(:formatted_response) { JSON.parse(response.body) }

    context 'when service deleted with sucess' do
      before { delete :destroy, params: { id: service.id } }

      it 'return no_content status code and success message' do
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'when service not found' do
      let(:not_found_code) { I18n.t('error_messages.service_not_found.code') }
      let(:not_found_title) { I18n.t('error_messages.service_not_found.title') }
      let(:not_found_detail) { I18n.t('error_messages.service_not_found.detail') }

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
        allow_any_instance_of(Service).to receive(:destroy).and_return(false)
        delete :destroy, params: { id: service.id }
      end

      it 'return unprocessable_entity status code and fail message' do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(formatted_response['message']).to eq('Falha ao deletar serviço')
      end
    end
  end
end