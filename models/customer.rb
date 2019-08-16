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




  #FINAL END
end
