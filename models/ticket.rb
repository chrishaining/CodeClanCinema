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

  #Count all tickets for a screening (not in itself a useful method, and would probably sit better in the screening class, but I've put it here to make it easier when I use the function in save)
  def Ticket.count_tickets_for_screening(screening)
    sql = "
    SELECT COUNT (*) FROM tickets
    WHERE tickets.screening_id = $1"
    values = [screening.id]
    tickets_for_screening = SqlRunner.run(sql, values)[0]
    return tickets_for_screening['count'].to_i
  end

  #CREATE a ticket. have refactored this to return if there is no capacity in the requested screening.
  def save(screening)
    return "That screening is full." if screening.capacity <= Ticket.count_tickets_for_screening(screening)
    sql = "
    INSERT INTO tickets
    (screening_id, customer_id)
    VALUES
    ($1, $2)
    RETURNING id
    "
    values = [@screening_id = screening.id, @customer_id]
    result = SqlRunner.run(sql, values)[0]
    @id = result['id'].to_i
  end

  #Shows all the customers (READ)
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

  #DELETE ticket class (so, delete all tickets)
  def self.delete_all
    sql = "DELETE FROM tickets"
    SqlRunner.run(sql)
  end

  #DELETE an instance of a tickets
  def delete
    sql = "DELETE FROM tickets WHERE id = $1"
    values = [id]
    SqlRunner.run(sql, values)
  end

  #gets only the ticket price. works as long as it is run on a valid ticket.
  def get_ticket_price
    sql = "
    SELECT films.price FROM films
    INNER JOIN screenings
    ON films.id = screenings.film_id
    INNER JOIN tickets
    ON tickets.screening_id = screenings.id
    WHERE tickets.id = $1
    "
    values = [@id]
    ticket_price = SqlRunner.run(sql, values)[0]['price'].to_i
    return ticket_price
  end

  #this function is to enable ticket sales. A bit strange, as the cinema wouldn't have direct access to this, but because we don't have an intermediary such as Worldpay, I think it is ok to put the function here. It works, as long as it is called on a valid ticket.
  def check_customer_funds
    sql = "
    SELECT customers.funds FROM customers
    INNER JOIN tickets
    ON tickets.customer_id = customers.id
    WHERE customers.id = $1"
    values = [@customer_id]
    result = SqlRunner.run(sql, values)[0]['funds'].to_i
    return result
  end

  #sells a ticket, and removes customer funds. Responsibility for removing the customer funds does not lie with the customer (once they have decided to buy the ticket, they no longer control whether money will come from their funds). I have put the customer as an argument so that the program can access customer.funds. If the transaction goes ahead, the ticket is deleted. This is so that it cannot be sold again. This has been only partly successful - although a ticket cannot be sold twice, it brings an error message on the second attempt.
  def sell_ticket(customer)
    return "Wrong customer!" if customer.id != self.customer_id
    return "Sorry - your payment is declined." if self.check_customer_funds < self.get_ticket_price
    return "There's no ticket!" unless defined?(self) != nil
    customer.funds -= self.get_ticket_price
    customer.update
    self.delete
    return "Thanks for buying the ticket."
  end

  # final end
end
