require('pg')
require_relative('../db/sql_runner')

#require_relative('./film')

class Customer

  attr_accessor :name, :funds
  attr_reader :id, :paid_tickets

  def initialize(options)
    @name = options['name']
    @funds = options['funds'].to_i
    @id = options['id'].to_i if options['id']
    @paid_tickets = []
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
    INNER JOIN screenings
    ON screenings.film_id = films.id
    INNER JOIN tickets
    ON tickets.screening_id = screenings.id
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


#function for customer to pay ticket. the function returns if the customer has already bought the ticket, has insufficient funds for the ticket, or if the ticket is not assigned to that customer. else, the function processes the payment, subtracts the price from the customer's funds, then updates the sql table.
  def pay_ticket(ticket)
    if @id == ticket.customer_id #not needed if tickets are only created once the program knows the customer can buy it.
      return "You already paid for this. We only charge you once per ticket." if paid_tickets.include? ticket #might be the cinema's responsibility?
      return "Sorry - your payment is declined due to lack of funds." if @funds < ticket.get_ticket_price #not sure about the responsibility here - would the cinema know that the customer lacks funds?
      new_funds = @funds -= ticket.get_ticket_price() #customer responsibility
      self.funds == new_funds #customer responsibility
      @paid_tickets.push(ticket) #customer responsibility
      self.update #customer responsibility
      return "Payment successful. Your remaining funds are #{new_funds}" #the customer's responsibility (cinema doesn't need to know customer's funds)
    end
    return "That is not your ticket!" #is this actually the cinema's responsibility?
  end

  #updated function for when the customer buys a ticket. refactored so that the only thing that happens on the customer class is that the funds come out of the account.
# def pay_for_ticket(ticket)
# PUT FUNCTION/FUNCTIONS FROM THE SCREENING OR TICKET CLASS
# new_funds = @funds -= ticket.get_ticket_price()
# self.funds = new_funds
# self.update
# return "Your remaining funds are are #{new_funds}."
# end

  #FINAL END
end
