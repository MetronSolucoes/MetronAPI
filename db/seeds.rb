Company.find_or_create_by(name: 'Cristian Barbinhas', opening_hours: 'Sexta a Sábado das 8 as 18', phone: '14997654323', email: 'cristian_cristian@gmail.com')

SchedulingStatus.find_or_create_by(id: 1, name: 'Livre')
SchedulingStatus.find_or_create_by(id: 2, name: 'Marcado')
SchedulingStatus.find_or_create_by(id: 3, name: 'Cancelado')
