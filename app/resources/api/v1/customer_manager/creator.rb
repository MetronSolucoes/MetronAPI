module Api::V1::CustomerManager
  class Creator < ApplicationManager::Creator
    private

    def execute_creation
      # cria o customer com todas as regras separadas em metodos, cada um realizando uma ação da criação de customer
    end
end