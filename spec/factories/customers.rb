FactoryBot.define do
  factory :customer do
    name { "Teste" }
    last_name { "Teste" }
    cpf { '69431952041' }
    phone { '1234567890' }
    email { 'teste@teste.com' }
  end
end