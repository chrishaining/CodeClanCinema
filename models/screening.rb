require('pg')
require_relative('../db/sql_runner')

class Screening

  attr_reader :id
  attr_accessor :film_id, :screening_time, :capacity

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @film_id = options['film_id'].to_i
    # @ticket_id = options['ticket_id'].to_i #do we need this, or can we get it from an inner join with tickets?
    @screening_time = options['screening_time'] #should this have a method to convert it to time?
    @capacity = options['capacity'].to_i
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

  #UPDATE a screening
  def update
    sql = "
    UPDATE screenings
    SET (film_id, screening_time, capacity) =
    ($1, $2, $3)
    WHERE id = $4
    "
    values = [@film_id, @screening_time, @capacity, @id]
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

#Set a limit to the available tickets for a screening
#The easiest way might be to do a return on the save method in ticket. So, return if number_of_tickets_sold >= capacity or return unless < capacity. But how will the program know 
# def restrict_tickets
#
# end

  #FINAL end
end
