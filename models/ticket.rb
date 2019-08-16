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



  # final end
end
