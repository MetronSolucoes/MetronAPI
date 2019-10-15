class CustomerSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :last_name, :cpf, :phone, :email
end
