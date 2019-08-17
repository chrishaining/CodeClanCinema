require('pg')
require_relative('../db/sql_runner')

#require_relative('./customer')

class Film

  attr_accessor :title, :price
  attr_reader :id

  def initialize(options)
    @title = options['title']
    @price = options['price'].to_i
    @id = options['id'].to_i if options['id']
  end

  #CREATE a film
  def save
    sql = "INSERT INTO films
    (title,
      price)
      VALUES ($1, $2)
      RETURNING *
      "
      values = [@title, @price]
      result = SqlRunner.run(sql, values)[0]
      @id = result['id'].to_i
    end

    #Shows all the films (READ)
    def self.show_all()
      sql = "SELECT * FROM films"
      all_films = SqlRunner.run(sql)
      result = all_films.map { |film| Film.new( film ) }
      return result
    end

#Shows all the  customers who are coming to see one film (READ)
    def customers
      sql = "SELECT customers.* FROM customers
      INNER JOIN tickets
      ON tickets.customer_id = customers.id
      WHERE film_id = $1"
      values = [@id]
      customers_info = SqlRunner.run(sql, values)
      customers_info.map { |customer| Customer.new(customer) }
    end

  #Basic extension: counts how many customers are coming to see one film (READ)
  def count_customers
     self.customers.length
  end

    #UPDATE method (on an instance of the film class)
    def update
      sql = "
      UPDATE films
      SET (title, price) =
      ()$1, $2)
      WHERE id = $3
      "
      values = [@title, @price, @id]
      SqlRunner.run(sql, values)
    end

    #DELETE ALL METHOD (ON THE FILM CLASS)
    def self.delete_all
      sql = "DELETE FROM films"
      SqlRunner.run(sql)
    end

    #DELETE method (on an instance of the film class)
    def delete(id)
      sql = "DELETE FROM films WHERE id = $1"
      values = [@id]
      SqlRunner.run(sql, values)
    end

    #FINAL END
  end
