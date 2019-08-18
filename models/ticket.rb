require('pg')
require_relative('../db/sql_runner')

class Ticket

  attr_reader :id
  attr_accessor :screening_id, :customer_id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @screening_id = options['screening_id'].to_i
    @customer_id = options['customer_id'].to_i
  end

  #CREATE a ticket I COULD ADD A LIMIT FOR SCREENING CAPACITY. REQUIRES ADDING SCREENING_ID
  def save
    sql = "
    INSERT INTO tickets
    (screening_id, customer_id)
    VALUES
    ($1, $2)
    RETURNING id
    "
    values = [@screening_id, @customer_id]
    result = SqlRunner.run(sql, values)[0]
    @id = result['id'].to_i
  end

  #Shows all the tickets (READ)
  def self.show_all()
    sql = "SELECT * FROM tickets"
    all_tickets = SqlRunner.run(sql)
    result = all_tickets.map { |ticket| Ticket.new( ticket ) }
    return result
  end

  #Basic extension to count the number of tickets a particular customer - NOT WORKING YET. IT ALWAYS RETURNS 0.
  def self.count_tickets_by_customer(customer)
    sql = "
    SELECT COUNT (*)
    FROM tickets
    WHERE customer_id = $1
    "
    values = [customer_id = customer.id]
    customers = SqlRunner.run(sql, values)[0]
    # result = customers.map { |customer| Customer.new(customer) }
    return "Customer with id #{customer.id} has #{customers['count'].to_i} tickets."
  end


  #UPDATE a ticket. Not very likely in the real-world, but in our system we have the ability to update. So, if a customer wants to watch a different film, they can change the film, or someone can give their ticket to someone else.
  def update
    sql = "
    UPDATE tickets
    SET (screening_id, customer_id) =
    ($1, $2)
    WHERE id = $3
    "
    values = [@screening_id, @customer_id, @id]
    SqlRunner.run(sql, values)
  end


  #DELETE all instances of the ticket class
  def self.delete_all
    sql = "DELETE FROM tickets"
    SqlRunner.run(sql)
  end

  #DELETE an instance of a tickets
  def delete
    sql = "DELETE FROM tickets WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end


  #the following function takes the ticket id and gets the price of the film and the customer funds. it then puts the price and funds into an array. The next step is to subtract the price from the funds, to leave remaining funds. However, this is not the function I want. It puts too much responsibility on the ticket class, and doesn't actually affect the customer's funds. so the next task for me is to transfer some of the code into the customer class. maybe the last two lines... (?) On second thoughts, it doesn't make sense to have the ticket class know about the customer's funds. it only needs to know the film price and customer id. So, the ticket class can take create an array or object containing price and customer id. it could then do a for loop/enumeration with a conditional. It would go through every customer and, if customers.id == customer_id, customers.funds -= price. (or can we do it using sql, maybe by having multiple - nested - functions?)

  #Sell tickets (could be best in screening class?. In screening, it can be called on a screening. In ticket, there is no ticket unless I have a premade stock of tickets that might not sell.)
  # def sell_ticket(customer)
  #   return "Sorry, tickets for that screening are sold out." if screening.sold_tickets.length >= screening.capacity
  #   return "Oops. It looks like you're trying to buy the same ticket twice." if screening.sold_tickets.include? self
  #   return "Sorry - your payment is declined." if customer.funds < screening.get_price
  #   screening.sold_tickets.push(self)
  #   screening.update
  #   screening_till.push(screening.get_price)
  #   self.update
  # end



# def add_to_sold_tickets
#     screening.sold_tickets.push()
# end


  #gets only the ticket price
  # def get_ticket_price
  #   sql =
  #   "SELECT films.price FROM films
  #   INNER JOIN tickets
  #   ON tickets.film_id = films.id
  #   WHERE tickets.id = $1"
  #   values = [@id]
  #   ticket_price = SqlRunner.run(sql, values)[0]['price'].to_i
  #   return ticket_price


  #FINAL END
end
