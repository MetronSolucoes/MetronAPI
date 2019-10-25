require 'rails_helper'

RSpec.describe Api::V1::ServicesController, type: :controller do

  describe 'POST #create' do
    context 'when service created with success' do

      let(:params) { { service: { name: 'Corte de Cabelo', description: 'Com Tesoura', duration: 1 } } }

      it 'returns service and created status code' do
        post :create, params: params

        body = JSON.parse(@response.body)

        expect(@response.status).to eq(201)
        expect(body['name']).to eq(params[:service][:name])
        expect(body['description']).to eq(params[:service][:description])
        expect(body['duration']).to eq(1)
      end
    end

    context 'when creation fails' do

      let(:invalid_params) { { service: { name: nil } } }

      before do
        allow_any_instance_of(Service).to receive(:save).and_return(false)
      end

      it 'returns unprocessable entity status code' do
        post :create, params: invalid_params

        body = JSON.parse(@response.body)

        expect(@response.status).to eq(422)
        expect(body['message']).to eq('Falha ao criar serviço')
      end
    end
  end

  describe 'GET #show' do

    context 'when service exists' do
      let!(:service) { create(:service) }

      it 'returns status code 200' do
        get :show, params: { id: service.id }

        body = JSON.parse(@response.body)

        expect(@response.status).to eq(200)
      end
    end

    context 'when service not found' do

      it 'returns not found message and status code 404' do
        get :show, params: { id: 'xpto' }

        body = JSON.parse(@response.body)

        expect(@response.status).to eq(404)
        expect(body['message']).to eq('Serviço não encontrado')
      end
    end
  end

  describe 'GET #index' do

    context 'when have services to index' do
      let!(:service) { create(:service) }

      it 'returns 200 status code, and services array is not null' do
        get :index

        body = JSON.parse(@response.body)

        expect(@response.status).to eq(200)
        expect(body['services']).not_to be_nil
      end
    end
  end

  describe 'PUT #update' do
    let!(:service) { create(:service) }
    let(:params) { { id: service.id, service: { name: 'Lavagem de cabelo', description: 'Com shampoo cheiroso' } } }

    context 'when service updated with success' do

      it 'returns 200 status code and updated service' do
        put :update, params: params

        body = JSON.parse(@response.body)

        expect(@response.status).to eq(200)
        expect(body['name']).to eq(params[:service][:name])
        expect(body['description']).to eq(params[:service][:description])
      end
    end

    context 'when updated fails' do

      before do
        allow_any_instance_of(Service).to receive(:update_attributes).and_return(false)
      end

      it 'returns 422 status code and fails message' do
        put :update, params: params

        body = JSON.parse(@response.body)

        expect(@response.status).to eq(422)
        expect(body['message']).to eq('Falha ao atualizar serviço')
      end
    end

    context 'when service not exits' do

      it 'returns 404 status code and not found message' do
        put :update, params: { id: '5684565' }

        body = JSON.parse(@response.body)

        expect(@response.status).to eq(404)
        expect(body['message']).to eq('Serviço não encontrado')
      end
    end
  end

  describe 'DELETE #destroy' do

    context 'when service deleted with sucess' do
    end
  end
end