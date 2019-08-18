require('pry')
require_relative('models/film')
require_relative('models/customer')
require_relative('models/ticket')
require_relative('models/screening')

Screening.delete_all()
Ticket.delete_all()
Film.delete_all()
Customer.delete_all()

film1 = Film.new({'title' => 'Goodfellas', 'price' => '8.00' })
film1.save

film2 = Film.new({'title' => 'The Godfather', 'price' => '5.00' })
film2.save

# film3 = Film.new({'title' => 'Casino', 'price' => '7.50' })
# film3.save
#
# film4 = Film.new({'title' => 'Mean Streets', 'price' => '8.00' })
# film4.save
#
# film5 = Film.new({'title' => 'Pulp Fiction', 'price' => '5.00' })
# film5.save

customer1 = Customer.new({ 'name' => 'Zelda', 'funds' => '300' })
customer1.save

customer2 = Customer.new({ 'name' => 'Fala', 'funds' => '100' })
customer2.save

# customer3 = Customer.new({ 'name' => 'Cama', 'funds' => '150' })
# customer3.save
#
# customer4 = Customer.new({ 'name' => 'Jemi', 'funds' => '30' })
# customer4.save
#
# customer5 = Customer.new({ 'name' => 'Kobo', 'funds' => '700' })
# customer5.save

screening1 = Screening.new({ 'film_id' => film1.id, 'screening_time' => '1200', 'capacity' => '100' })
screening1.save

screening2 = Screening.new({ 'film_id' => film2.id, 'screening_time' => '1600', 'capacity' => '150' })
screening2.save

# screening3 = Screening.new({ 'film_id' => film1.id, 'screening_time' => '2000', 'capacity' => '200' })
# screening3.save
#
# screening4 = Screening.new({ 'film_id' => film2.id, 'screening_time' => '1000', 'capacity' => '100' })
# screening4.save
#
# screening5 = Screening.new({ 'film_id' => film2.id, 'screening_time' => '2200', 'capacity' => '50' })
# screening1.save
#
# screening6 = Screening.new({ 'film_id' => film3.id, 'screening_time' => '1200', 'capacity' => '100' })
# screening6.save
#
# screening7 = Screening.new({ 'film_id' => film4.id, 'screening_time' => '1400', 'capacity' => '100' })
# screening7.save
#
# screening8 = Screening.new({ 'film_id' => film4.id, 'screening_time' => '2000', 'capacity' => '50' })
# screening8.save
#
# screening9 = Screening.new({ 'film_id' => film5.id, 'screening_time' => '2200', 'capacity' => '50' })
# screening9.save
#
# screening10 = Screening.new({ 'film_id' => film5.id, 'screening_time' => '2200', 'capacity' => '100' })
# screening10.save

ticket1 = Ticket.new({ 'screening_id' => screening1.id, 'customer_id' => customer1.id })
ticket1.save

ticket2 = Ticket.new({ 'screening_id' => screening2.id, 'customer_id' => customer2.id })
ticket2.save

# ticket3 = Ticket.new({ 'film_id' => film1.id, 'customer_id' => customer3.id })
# ticket3.save
#
# ticket4 = Ticket.new({ 'film_id' => film2.id, 'customer_id' => customer1.id })
# ticket4.save
#
# ticket5 = Ticket.new({ 'film_id' => film3.id, 'customer_id' => customer4.id })
# ticket5.save
#
# ticket6 = Ticket.new({ 'film_id' => film3.id, 'customer_id' => customer5.id })
# ticket6.save
#
# ticket7 = Ticket.new({ 'film_id' => film4.id, 'customer_id' => customer3.id })
# ticket7.save




binding.pry
nil
