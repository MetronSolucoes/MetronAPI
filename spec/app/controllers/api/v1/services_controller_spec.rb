require 'rails_helper'

RSpec.describe Api::V1::ServicesController, type: :controller do

  describe 'POST #create' do
    context 'when service created with success' do

      let(:params) { { service: { name: 'Corte de Cabelo', description: 'Com Tesoura', duration: 1 } } }

      it 'returns 201 status code' do
        post :create, params: params

        expect(@response.status).to eq(201)
      end
    end
  end
end