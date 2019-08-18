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

    #REDO
    #Shows all the customers who are coming to see one film (READ)
    # def customers
    #   sql = "SELECT customers.* FROM customers
    #   INNER JOIN tickets
    #   ON tickets.customer_id = customers.id
    #   WHERE tickets.film_id = $1"
    #   values = [@id]
    #   customers_info = SqlRunner.run(sql, values)
    #   customers_info.map { |customer| Customer.new(customer) }
    # end

    #Basic extension: counts how many cusotmers are coming to see one film (READ)
    def count_customers
      self.customers.length
    end

    #idea for advanced extensions (READ)
    def show_most_popular_screening_time()
      sql = "
      SELECT screenings.screening_time FROM screenings
      INNER JOIN tickets
      ON tickets.screening_id = screenings.id
      WHERE screenings.film_id = $1"
      values = [@id]
      screening_times = SqlRunner.run(sql, values)
      times = screening_times.map { |screening| Screening.new(screening).screening_time  }
      return "The most popular time for this film is #{times.max_by {|time| times.count(time)}}" 
    end


    # SELECT screening_time FROM screenings
    # INNER JOIN tickets
    # ON tickets.screening_id = screenings.id
    # WHERE tickets.film_id = $1
    #Advanced extension: find out the most popular screening_time for a given film
    #In ticket, create a class function to map the number of tickets sold per screening - maybe screening.screening_time . should produce a collection of all tickets. inner join on screenings to get film times?
    #using this function, go to film.




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
    def delete
      sql = "DELETE FROM films WHERE id = $1"
      values = [@id]
      SqlRunner.run(sql, values)
    end

    #FINAL END
  end
