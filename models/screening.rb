require('pg')
require_relative('../db/sql_runner')

class Screening

  attr_reader :id
  attr_accessor :film_id, :screening_time, :capacity, :available_tickets, :sold_tickets

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @film_id = options['film_id'].to_i
    # @ticket_id = options['ticket_id'].to_i #do we need this, or can we get it from an inner join with tickets?
    @screening_time = options['screening_time'] #should this have a method to convert it to time?
    @capacity = options['capacity'].to_i
    @available_tickets = []
    @sold_tickets = []
  end

  #CREATE a screening
  def save
    sql = "
    INSERT INTO screenings
    (film_id, screening_time, capacity)
    VALUES ($1, $2, $3)
    RETURNING id
    "
    values = [@film_id, @screening_time, @capacity]
    result = SqlRunner.run(sql, values)[0]
    @id = result['id'].to_i
  end

  #Shows all the screenings (READ)
def self.show_all_screenings
  sql = "
  SELECT * FROM screenings"
  all_screenings = SqlRunner.run(sql)
  result = all_screenings.map { |screening| Screening.new( screening ) }
  return result
end

def show_screening_time(film)
  sql = "
  SELECT screening_time FROM screenings
  WHERE
  "


end
  #UPDATE a screening - how do I deal with sold_tickets
  def update
    sql = "
    UPDATE screenings
    SET (film_id, screening_time, capacity, available_tickets, sold_tickets) =
    ($1, $2, $3, $4, $5)
    WHERE id = $6
    "
    values = [@film_id, @screening_time, @capacity, @available_tickets, @sold_tickets, @id]
    SqlRunner.run(sql, values)
  end

  #DELETE all instances of the screening class
  def self.delete_all
    sql = "DELETE FROM screenings"
     SqlRunner.run(sql)
  end

  #DELETE an instance of a tickets
def delete
  sql = "DELETE FROM screenings WHERE id = $1"
  values = [@id]
  SqlRunner.run(sql, values)
end

#get price for a film version 2
def get_price
  sql =
    "SELECT films.price FROM films
    INNER JOIN screenings
    ON screenings.film_id = films.id
    WHERE screenings.id = $1"
    values = [@id]
    screening_price = SqlRunner.run(sql, values)[0]['price'].to_i
    return screening_price
end

#function to find whether there is a ticket available for a particular screening
def ticket_exists?()
  sql = "
  SELECT * FROM tickets
  WHERE tickets.screening_id = $1
  "
 values=[@id]
  result = SqlRunner.run(sql, values)
  available_tickets = result.map { |ticket| Ticket.new(ticket) }
  return available_tickets.length > 0
  self.update
end


def sell_ticket(customer)
  self.ticket_exists?()
  return if self.ticket_exists?() == false
  return "Sorry, tickets for that screening are sold out." if self.sold_tickets.length >= self.capacity
  return "Oops. It looks like you're trying to buy the same ticket twice." if self.sold_tickets.include? self
  return "Sorry - your payment is declined." if customer.funds < self.get_price
  #return if customer id does not match ticket id. seems stupid, but part of legacy of program
  #it might also be useful to return if the ticket is not available. but how do you find an available ticket?
  sold_ticket = available_tickets[0]
  self.sold_tickets.push(sold_ticket)
  self.available_tickets.delete(sold_ticket)
  #screening_till.push(screening.get_price)
  self.update
end

#get price for a film version 1. BUT I WANT TO GET RID OF tickets.film_id
# def get_price
#   sql =
#     "SELECT films.price FROM films
#     INNER JOIN tickets
#     ON tickets.film_id = films.id
#     WHERE tickets.id = $1"
#     values = [@id]
#     screening_price = SqlRunner.run(sql, values)[0]['price'].to_i
#     return screening_price
# end





# INNER JOIN screenings
# ON screenings.film_id = films.id



#Set a limit to the available tickets for a screening
#The easiest way might be to do a return on the save method in ticket. So, return if number_of_tickets_sold >= capacity or return unless < capacity. But how will the program know
# def restrict_tickets
#
# end

  #FINAL end
end
