require('pg')
require_relative('../db/sql_runner')

class Ticket

  attr_reader :id
  attr_accessor :film_id, :customer_id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @film_id = options['film_id'].to_i
    @customer_id = options['customer_id'].to_i
  end

  #CREATE a ticket
  def save
    sql = "
    INSERT INTO tickets
    (film_id, customer_id)
    VALUES
    ($1, $2)
    RETURNING id
    "
    values = [@film_id, @customer_id]
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
      SET (film_id, customer_id) =
      ($1, $2)
      WHERE id = $3
      "
      values = [@film_id, @customer_id, @id]
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

    #SEllING A Ticket
    #   def get_ticket_price
    #     sql = "SELECT price FROM FILMS
    #     WHERE films.id = $1"
    #     values = [@film_id]
    #     ticket_price = SqlRunner.run(sql, values)
    #     return ticket_price
    # end


    # def get_ticket_price
    #   sql = "
    #   SELECT films.price, customers.funds FROM FILMS
    #   INNER JOIN tickets
    #   ON tickets.film_id = films.id
    #   INNER JOIN customers
    #   ON customer_id = customers.id
    #   WHERE tickets.id = $1"
    #   values = [@id]
    #   ticket_price = SqlRunner.run(sql, values)
    #   return ticket_price
    # end

    #the following function takes the ticket id and gets the price of the film and the customer funds. it then puts the price and funds into an array. The next step is to subtract the price from the funds, to leave remaining funds. However, this is not the function I want. It puts too much responsibility on the ticket class, and doesn't actually affect the customer's funds. so the next task for me is to transfer some of the code into the customer class. maybe the last two lines... (?) On second thoughts, it doesn't make sense to have the ticket class know about the customer's funds. it only needs to know the film price and customer id. So, the ticket class can take create an array or object containing price and customer id. it could then do a for loop/enumeration with a conditional. It would go through every customer and, if customers.id == customer_id, customers.funds -= price. (or can we do it using sql, maybe by having multiple - nested - functions?)

    #Gets ticket_price and customer funds
    # def get_ticket_price
    #   sql =
    #   "SELECT films.price, customers.funds FROM films
    #   INNER JOIN tickets
    #   ON tickets.film_id = films.id
    #   INNER JOIN customers
    #   ON customer_id = customers.id
    #   WHERE tickets.id = $1"
    #   values = [@id]
    #   ticket_price_and_funds = SqlRunner.run(sql, values)[0]
    #   remaining_funds = ticket_price_and_funds.map { |price, funds| funds.to_i - price.to_i}
    #   #return remaining_funds[1] - remaining_funds[0]
    # end

    #gets only the ticket price
    def get_ticket_price
      sql =
      "SELECT films.price FROM films
      INNER JOIN tickets
      ON tickets.film_id = films.id
      WHERE tickets.id = $1"
      values = [@id]
      ticket_price = SqlRunner.run(sql, values)[0]['price'].to_i
      return ticket_price
      #ticket_price.map { |price| price.to_i}
      #  remaining_funds = ticket_price_and_funds.map { |price, funds| funds.to_i - price.to_i}
      #return remaining_funds[1] - remaining_funds[0]
    end

    #
    # films = self.films
    # prices = films.map { |film| film.price}
    # customer_payments = []
    # prices.each { |price| customer_payments.push(price) }
    # total_paid = customer_payments.reduce(:+)
    # @funds -= total_paid
    # ticket_price.map { || }
    #
    #
    # prices = films.map { |film| film.price}
    # customer_data = results[0]
    # customer = Customer.new(customer_data)
    # return customer



    # def sell_ticket
    #   sql = "SELECT films.price, customers.id FROM films
    #   INNER JOIN tickets
    #   ON tickets.film_id = films.id
    #   INNER JOIN customers
    #   ON tickets.customer_id = customers.id
    #   WHERE tickets.id = $1"
    #   values = [@id]
    #   ticket_prices = SqlRunner.run(sql, values)
    #   p ticket_prices
    # end


    #IDEA FOR PULLING PRICE
    # SELECT films.price, customers.name FROM films
    # INNER JOIN tickets
    # ON tickets.film_id = films.id
    # INNER JOIN customers
    # ON customers.id = customer_id
    # WHERE customers.id = 111
    # final end
  end
