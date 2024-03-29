require('pry')
require_relative('models/film')
require_relative('models/customer')
require_relative('models/ticket')

Ticket.delete_all()
Film.delete_all()
Customer.delete_all()

film1 = Film.new({'title' => 'Goodfellas', 'price' => '8.00'})
film1.save

film2 = Film.new({'title' => 'The Godfather', 'price' => '5.00'})
film2.save

film3 = Film.new({'title' => 'Casino', 'price' => '7.50'})
film3.save

film4 = Film.new({'title' => 'Mean Streets', 'price' => '8.00'})
film4.save

film5 = Film.new({'title' => 'Pulp Fiction', 'price' => '5.00'})
film5.save

customer1 = Customer.new({ 'name' => 'Zelda', 'funds' => '300'})
customer1.save

customer2 = Customer.new({ 'name' => 'Fala', 'funds' => '100'})
customer2.save

customer3 = Customer.new({ 'name' => 'Cama', 'funds' => '150'})
customer3.save

customer4 = Customer.new({ 'name' => 'Jemi', 'funds' => '30'})
customer4.save

customer5 = Customer.new({ 'name' => 'Kobo', 'funds' => '700'})
customer5.save

ticket1 = Ticket.new({ 'film_id' => film1.id, 'customer_id' => customer1.id})
ticket1.save

ticket2 = Ticket.new({ 'film_id' => film1.id, 'customer_id' => customer2.id})
ticket2.save

ticket3 = Ticket.new({ 'film_id' => film1.id, 'customer_id' => customer3.id})
ticket3.save

ticket4 = Ticket.new({ 'film_id' => film2.id, 'customer_id' => customer1.id})
ticket4.save

ticket5 = Ticket.new({ 'film_id' => film3.id, 'customer_id' => customer4.id})
ticket5.save

ticket6 = Ticket.new({ 'film_id' => film3.id, 'customer_id' => customer5.id})
ticket6.save

ticket7 = Ticket.new({ 'film_id' => film4.id, 'customer_id' => customer3.id})
ticket7.save



binding.pry
nil
