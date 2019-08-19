DROP TABLE IF EXISTS tickets;
DROP TABLE IF EXISTS screenings;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS films;

CREATE TABLE films (
id SERIAL8 PRIMARY KEY,
title VARCHAR(255),
price INT4
);

CREATE TABLE customers (
  id SERIAL8 PRIMARY KEY,
  name VARCHAR(255),
  funds INT4
);

CREATE TABLE screenings (
   id SERIAL8 PRIMARY KEY, --film_id INT8 REFERENCES films(id) ON DELETE CASCADE,
   film_id INT8 REFERENCES films(id) ON DELETE CASCADE,
   screening_time TIME, --I'm not sure if this should be TIME or VARCHAR
   capacity INT4
);

CREATE TABLE tickets (
  id SERIAL8 PRIMARY KEY,
  screening_id INT8 REFERENCES screenings(id) ON DELETE CASCADE,
  customer_id INT8 REFERENCES customers(id) ON DELETE CASCADE,
  status VARCHAR(255)
);
