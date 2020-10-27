company = Company.find_or_create_by(name: 'Cristian Barbinhas',
                                    phone: '14997654323',
                                    email: 'cristian_cristian@gmail.com')

if User.find_by(email: 'admin@metron.com').blank?
  User.create(company_id: company.id, name: 'Administrador', email: 'admin@metron.com',
              password: 'mudar123', password_confirmation: 'mudar123', profile_id: User::ADMIN_PROFILE)
end

SchedulingStatus.find_or_create_by(id: 1, name: 'Livre')
SchedulingStatus.find_or_create_by(id: 2, name: 'Marcado')
SchedulingStatus.find_or_create_by(id: 3, name: 'Cancelado')

employe = Employe.find_or_create_by(name: 'Cristian', last_name: 'Barbinhas', phone: '14970707070',
                                    email: 'cristian_barbinhas@barbearia.com', company_id: company.id)

employe2 = Employe.find_or_create_by(name: 'Rafa', last_name: 'Couto', phone: '14997485567',
                                     email: 'rafa.couto@barbearia.com', company_id: company.id)

employe3 = Employe.find_or_create_by(name: 'Giovani', last_name: 'Zaparoli', phone: '14970607070',
                                     email: 'giovani.zaparoli@barbearia.com', company_id: company.id)

service = Service.find_or_create_by(name: 'Corte e barba', description: 'Corte e barba', duration: 30)
service2 = Service.find_or_create_by(name: 'Tingimento', description: 'Pintura de cabelo', duration: 45)
service3 = service = Service.find_or_create_by(name: 'Corte de maquina', description: 'Corte feito somente na maquina', duration: 30)

EmployeService.find_or_create_by(employe_id: employe.id, service_id: service.id)
EmployeService.find_or_create_by(employe_id: employe.id, service_id: service2.id)
EmployeService.find_or_create_by(employe_id: employe2.id, service_id: service3.id)
EmployeService.find_or_create_by(employe_id: employe2.id, service_id: service2.id)
EmployeService.find_or_create_by(employe_id: employe3.id, service_id: service.id)
EmployeService.find_or_create_by(employe_id: employe3.id, service_id: service3.id)


(OpeningHour::MONDAY..OpeningHour::FRIDAY).each do |i|
  OpeningHour.find_or_create_by(opening_time: '08:00:00', closing_time: '18:00:00', weekday: i, company_id: company.id)
end
