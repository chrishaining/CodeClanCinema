require('pg')
require_relative('../db/sql_runner')

#require_relative('./film')

class Customer

  attr_accessor :name, :funds
  attr_reader :id

  def initialize(options)
    @name = options['name']
    @funds = options['funds'].to_i
    @id = options['id'].to_i if options['id']
  end

  #CREATE an instance of the Customer class.
  def save
    sql = "INSERT INTO customers
    (name, funds)
    VALUES ($1, $2)
    RETURNING *
    "
    values = [@name, @funds]
    result = SqlRunner.run(sql, values)[0]
    @id = result['id'].to_i
  end

  #Shows all the customers (READ)
  def self.show_all()
    sql = "SELECT * FROM customers"
    all_customers = SqlRunner.run(sql)
    result = all_customers.map { |customer| Customer.new( customer ) }
    return result
  end

  #Shows all the films a specific customer has booked to see (READ)
  def films
    sql = "SELECT films.* FROM films
    INNER JOIN tickets
    ON tickets.film_id = films.id
    WHERE customer_id = $1"
    values = [@id]
    films_info = SqlRunner.run(sql, values)
    films_info.map { |film| Film.new(film) }
  end

#Basic extension shows all the tickets a customer has bought (READ)
  def count_tickets()
     sql = "
     SELECT * FROM tickets
     WHERE customer_id = $1
     "
     values = [@id]
    tickets = SqlRunner.run(sql, values)
    result = tickets.map { |ticket| Ticket.new(ticket) }
      return result.length
    end

  #UPDATE an instance
  def update
    sql = "
    UPDATE customers
    SET (name, funds) =
    ($1, $2)
    WHERE id = $3
    "
    values = [@name, @funds, @id]
    SqlRunner.run(sql, values)
  end

  #DELETE the class
  def self.delete_all
    sql = "DELETE FROM customers"
    SqlRunner.run(sql)
  end

  #DELETE an instance
  def delete
    sql = "DELETE FROM customers WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  #Basic extension - a method that decreases customer funds when they buy a ticket
  #the price is in the films table, so an inner join will be required at the tickets table, specifically on the films_id property.
  #this will pull through too much info - we only want to access the price.
  #some kind of loop or enumeration method may help to loop through the objects (films), return the prices and subtract the prices from the funds.

  #  def pay_ticket(ticket)
  #    return "That is not your ticket!" if @id != ticket.customer_id
  #   ticket.get_ticket_price()
  #   @funds = @funds - ticket_price
  #
  #
  #   return @funds
  # end

  def pay_ticket(ticket)
    if @id == ticket.customer_id
      new_funds = @funds -= ticket.get_ticket_price()
      self.funds == new_funds
      self.update
      return "Payment successful. Your remaining funds are #{new_funds}"
      # return "Payment successful. Your remaining funds are #{@funds -= ticket.get_ticket_price()}"
    end
    return "That is not your ticket!"
  end

  # def get_prices
  #   sql = "SELECT price FROM films
  #   INNER JOIN tickets
  #   ON tickets.film_id = films.id
  #   WHERE customer_id = $1"
  #   values = [@id]
  #   films_info = SqlRunner.run(sql, values)
  #   films_info.map { |price| Film.new(price) }
  # end
  #
  # def pay_for_tickets
  #   films = self.films
  #   prices = films.map { |film| film.price}
  #   customer_payments = []
  #   prices.each { |price| customer_payments.push(price) }
  #   total_paid = customer_payments.reduce(:+)
  #   @funds -= total_paid
  # end



  #FINAL END
end
