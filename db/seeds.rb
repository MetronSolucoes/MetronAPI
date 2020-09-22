company = Company.find_or_create_by(name: 'Cristian Barbinhas',
                                    opening_hours: 'Sexta a Sábado das 8 as 18',
                                    phone: '14997654323',
                                    email: 'cristian_cristian@gmail.com')

if User.find_by(email: 'admin@immunizesystem.com').blank?
  User.create(company_id: company.id, name: 'Administrador', email: 'admin@metron.com',
              password: 'mudar123', password_confirmation: 'mudar123')
end

SchedulingStatus.find_or_create_by(id: 1, name: 'Livre')
SchedulingStatus.find_or_create_by(id: 2, name: 'Marcado')
SchedulingStatus.find_or_create_by(id: 3, name: 'Cancelado')

employe = Employe.find_or_create_by(name: 'Cristian', last_name: 'Barbinhas', phone: '14970707070',
                                    email: 'cristian_barbinhas@barbearia.com', company_id: company.id)

service = Service.find_or_create_by(name: 'Corte e barba', description: 'Corte e barba', duration: 30)
EmployeService.find_or_create_by(employe_id: employe.id, service_id: service.id)

(OpeningHour::MONDAY..OpeningHour::FRIDAY).each do |i|
  OpeningHour.find_or_create_by(opening_time: '08:00:00', closing_time: '18:00:00', weekday: i, company_id: company.id)
end
