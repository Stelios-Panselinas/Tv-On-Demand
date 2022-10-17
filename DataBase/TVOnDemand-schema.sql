-- Database TVOnDemand 

-- based on

-- Sakila Sample Database Schema
-- Version 1.2

-- Copyright (c) 2006, 2019, Oracle and/or its affiliates.

-- Redistribution and use in source and binary forms, with or without
-- modification, are permitted provided that the following conditions are
-- met:

-- * Redistributions of source code must retain the above copyright notice,
--   this list of conditions and the following disclaimer.
-- * Redistributions in binary form must reproduce the above copyright
--   notice, this list of conditions and the following disclaimer in the
--   documentation and/or other materials provided with the distribution.
-- * Neither the name of Oracle nor the names of its contributors may be used
--   to endorse or promote products derived from this software without
--   specific prior written permission.

-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
-- IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
-- THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
-- PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
-- CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
-- EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
-- PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
-- PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
-- LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
-- NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
-- SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.



DROP SCHEMA IF EXISTS tvondemand;
CREATE SCHEMA tvondemand;
USE tvondemand;

--
-- Table structure for table `actor`
--

CREATE TABLE actor (
  actor_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  first_name VARCHAR(45) NOT NULL,
  last_name VARCHAR(45) NOT NULL,
  PRIMARY KEY  (actor_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;




--
-- Table structure for table `country`
--

CREATE TABLE country (
  country_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  country VARCHAR(50) NOT NULL,
  PRIMARY KEY  (country_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



--
-- Table structure for table `city`
--

CREATE TABLE city (
  city_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  city VARCHAR(50) NOT NULL,
  country_id SMALLINT UNSIGNED NOT NULL,
  PRIMARY KEY  (city_id),
  CONSTRAINT `fk_city_country` FOREIGN KEY (country_id) REFERENCES country (country_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Table structure for table `address`
--

CREATE TABLE address (
  address_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  address VARCHAR(50) NOT NULL,
  district VARCHAR(20) DEFAULT NULL,
  city_id SMALLINT UNSIGNED NOT NULL,
  postal_code VARCHAR(10) DEFAULT NULL,
  phone VARCHAR(20) NOT NULL,
  PRIMARY KEY  (address_id),
  CONSTRAINT `fk_address_city` FOREIGN KEY (city_id) REFERENCES city (city_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Table structure for table `category`


CREATE TABLE category (
  category_id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  name VARCHAR(25) NOT NULL,
  PRIMARY KEY  (category_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


--
-- Table structure for table `language`
--

CREATE TABLE language (
  language_id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  name CHAR(20) NOT NULL,
  PRIMARY KEY (language_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Table structure for table `customer`


CREATE TABLE customer (
  customer_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  first_name VARCHAR(45) NOT NULL,
  last_name VARCHAR(45) NOT NULL,
  email VARCHAR(50) DEFAULT NULL,
  address_id SMALLINT UNSIGNED NOT NULL,
  active BOOLEAN NOT NULL DEFAULT TRUE,
  create_date DATETIME NOT NULL,
  registration ENUM('M','S','MS'),
  PRIMARY KEY  (customer_id),
  CONSTRAINT fk_customer_address FOREIGN KEY (address_id) REFERENCES address (address_id) ON DELETE RESTRICT ON UPDATE CASCADE
  )ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Table structure for table 'employee' 

CREATE TABLE employee (
  employee_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  first_name VARCHAR(45) NOT NULL,
  last_name VARCHAR(45) NOT NULL,
  email VARCHAR(50) DEFAULT NULL,
  address_id SMALLINT UNSIGNED NOT NULL,
  active BOOLEAN NOT NULL DEFAULT TRUE,
  create_date DATETIME NOT NULL,
  PRIMARY KEY  (employee_id),
  CONSTRAINT fk_employee_address FOREIGN KEY (address_id) REFERENCES address (address_id) ON DELETE RESTRICT ON UPDATE CASCADE
  )ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- Table structure for table 'administrator'


CREATE TABLE administrator(
  administrator_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  first_name VARCHAR(45) NOT NULL,
  last_name VARCHAR(45) NOT NULL,
  email VARCHAR(50) DEFAULT NULL,
  address_id SMALLINT UNSIGNED NOT NULL,
  create_date DATETIME NOT NULL,
  PRIMARY KEY (administrator_id),
  CONSTRAINT fk_administrator_address FOREIGN KEY (address_id) REFERENCES address (address_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

--
-- Table structure for table `film`
--

CREATE TABLE film (
  film_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  title VARCHAR(128) NOT NULL,
  description TEXT DEFAULT NULL,
  release_year YEAR DEFAULT NULL,
  language_id TINYINT UNSIGNED NOT NULL,
  original_language_id TINYINT UNSIGNED DEFAULT NULL,
  length SMALLINT UNSIGNED DEFAULT NULL,
  rating ENUM('G','PG','PG-13','R','NC-17') DEFAULT 'G',
  special_features SET('Trailers','Commentaries','Deleted Scenes','Behind the Scenes') DEFAULT NULL,
  PRIMARY KEY  (film_id),
  CONSTRAINT fk_film_language FOREIGN KEY (language_id) REFERENCES language (language_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_film_language_original FOREIGN KEY (original_language_id) REFERENCES language (language_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Table structure for table 'series'
--

CREATE TABLE series(
series_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
title VARCHAR(128) NOT NULL,
description TEXT DEFAULT NULL,
release_year YEAR DEFAULT NULL,
language_id TINYINT UNSIGNED NOT NULL,
original_language_id TINYINT UNSIGNED DEFAULT NULL,
seasons SMALLINT UNSIGNED DEFAULT NULL,
rating ENUM('G','PG','PG-13','R','NC-17') DEFAULT 'G',
special_features SET('Trailers','Commentaries','Deleted Scenes','Behind the Scenes') default null,
PRIMARY KEY (series_id),
CONSTRAINT fk_series_language FOREIGN KEY (language_id) REFERENCES language (language_id) ON DELETE RESTRICT ON UPDATE CASCADE,
CONSTRAINT fk_series_language_original FOREIGN KEY (original_language_id) REFERENCES language (language_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

--
-- Table for structure table 'episodes'
--

CREATE TABLE episodes(
series_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
seasons SMALLINT UNSIGNED NOT NULL,
episode SMALLINT UNSIGNED NOT NULL,
length SMALLINT UNSIGNED DEFAULT NULL,
CONSTRAINT episodes_per_season FOREIGN KEY (series_id) REFERENCES series (series_id) ON DELETE CASCADE ON UPDATE CASCADE
);

--
-- Table structure for table `film_actor`
--

CREATE TABLE film_actor (
  actor_id SMALLINT UNSIGNED NOT NULL,
  film_id SMALLINT UNSIGNED NOT NULL,
  PRIMARY KEY  (actor_id,film_id),
  CONSTRAINT fk_film_actor_actor FOREIGN KEY (actor_id) REFERENCES actor (actor_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_film_actor_film FOREIGN KEY (film_id) REFERENCES film (film_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Table structure for table 'series_actor'
--

CREATE TABLE series_actor(
  actor_id SMALLINT UNSIGNED NOT NULL,
  series_id SMALLINT UNSIGNED NOT NULL,
  PRIMARY KEY (actor_id,series_id),
  CONSTRAINT fk_series_actor_actor FOREIGN KEY (actor_id) REFERENCES actor (actor_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_series_actor_series FOREIGN KEY (series_id) REFERENCES series (series_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

--
-- Table structure for table `film_category`
--

CREATE TABLE film_category (
  film_id SMALLINT UNSIGNED NOT NULL,
  category_id TINYINT UNSIGNED NOT NULL,
  PRIMARY KEY (film_id, category_id),
  CONSTRAINT fk_film_category_film FOREIGN KEY (film_id) REFERENCES film (film_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_film_category_category FOREIGN KEY (category_id) REFERENCES category (category_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
--Table structure for table 'series_category'
--

CREATE TABLE series_category(
  series_id SMALLINT UNSIGNED NOT NULL,
  category_id TINYINT UNSIGNED NOT NULL,
  CONSTRAINT fk_series_category_series FOREIGN KEY (series_id) REFERENCES series (series_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_series_category_category FOREIGN KEY (category_id) REFERENCES category (category_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

--
-- Table structure for table 'film_mod'
--

CREATE TABLE film_mod(
  film_id SMALLINT UNSIGNED NOT NULL,
  employee_id SMALLINT UNSIGNED NOT NULL,
  CONSTRAINT fk_film_insertion_film FOREIGN KEY (film_id) REFERENCES film (film_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_film_insertion_employee FOREIGN KEY (employee_id) REFERENCES employee (employee_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

--
-- Table structure for table 'series_mod'
--

CREATE TABLE series_mod (
  series_id SMALLINT UNSIGNED NOT NULL,
  employee_id SMALLINT UNSIGNED NOT NULL,
  CONSTRAINT fk_series_mod_series FOREIGN KEY (series_id) REFERENCES series (series_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_series_insertion_employee FOREIGN KEY (employee_id) REFERENCES employee (employee_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

--
-- Table structure for table `inventory`
--

CREATE TABLE film_inventory (
  inventory_id MEDIUMINT UNSIGNED NOT NULL AUTO_INCREMENT,
  film_id SMALLINT UNSIGNED NOT NULL,
  PRIMARY KEY  (inventory_id),
  CONSTRAINT fk_inventory_film FOREIGN KEY (film_id) REFERENCES film (film_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Table for structur table 'series_inventory'
--

CREATE TABLE series_inventory(
  inventory_id MEDIUMINT UNSIGNED NOT NULL AUTO_INCREMENT,
  series_id SMALLINT UNSIGNED NOT NULL,
  PRIMARY KEY (inventory_id),
  CONSTRAINT fk_inventory_series FOREIGN KEY (series_id) REFERENCES series (series_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

--
-- Table structure for table `rental`
--

CREATE TABLE film_rental (
  rental_id INT NOT NULL AUTO_INCREMENT,
  rental_date DATETIME NOT NULL,
  inventory_id MEDIUMINT UNSIGNED NOT NULL,
  customer_id SMALLINT UNSIGNED NOT NULL,
  PRIMARY KEY (rental_id),
  UNIQUE KEY  (rental_date,inventory_id,customer_id),
  CONSTRAINT fk_rental_inventory FOREIGN KEY (inventory_id) REFERENCES film_inventory (inventory_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_rental_customer FOREIGN KEY (customer_id) REFERENCES customer (customer_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
--Table structure for table 'series_rental'
--

CREATE TABLE series_rental(
  rental_id INT NOT NULL AUTO_INCREMENT,
  rental_date DATETIME NOT NULL,
  inventory_id MEDIUMINT UNSIGNED NOT NULL,
  customer_id SMALLINT UNSIGNED NOT NULL,
  PRIMARY KEY (rental_id),
  UNIQUE KEY  (rental_date,inventory_id,customer_id),
  CONSTRAINT series_rental_inventory FOREIGN KEY (inventory_id) REFERENCES series_inventory (inventory_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT series_rental_customer FOREIGN KEY (customer_id) REFERENCES customer (customer_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
--Table structure for table 'series_payment'
--

CREATE TABLE series_payment (
  payment_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  customer_id SMALLINT UNSIGNED NOT NULL,
  rental_id INT DEFAULT NULL,
  amount DECIMAL(5,2) NOT NULL,
  payment_date DATETIME NOT NULL,
  PRIMARY KEY  (payment_id),
  CONSTRAINT series_payment_rental FOREIGN KEY (rental_id) REFERENCES series_rental (rental_id) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT series_payment_customer FOREIGN KEY (customer_id) REFERENCES customer (customer_id) ON DELETE RESTRICT ON UPDATE CASCADE
 ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Table structure for table `payment`
--

CREATE TABLE film_payment (
  payment_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  customer_id SMALLINT UNSIGNED NOT NULL,
  rental_id INT DEFAULT NULL,
  amount DECIMAL(5,2) NOT NULL,
  payment_date DATETIME NOT NULL,
  PRIMARY KEY  (payment_id),
  CONSTRAINT fk_payment_rental FOREIGN KEY (rental_id) REFERENCES film_rental (rental_id) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT fk_payment_customer FOREIGN KEY (customer_id) REFERENCES customer (customer_id) ON DELETE RESTRICT ON UPDATE CASCADE
 ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Table structure for table 'log'
--

CREATE TABLE log(
  username VARCHAR(50) NOT NULL,
  user ENUM('C','E','A') DEFAULT 'C',
  movement ENUM('INSERT','UPDATE','DELETE'),
  date DATETIME,
  success BOOLEAN,
  table_name VARCHAR(50),
  PRIMARY KEY(username)
);

--
-- Stored procedure for the incomes from films
--

DELIMITER $
CREATE PROCEDURE film_incomes(IN month_input VARCHAR(10))
  BEGIN
      SET @month=month_input;
      SELECT SUM(amount) FROM payment 
      INNER JOIN rental ON payment.rental_id=rental.rental_id 
      INNER JOIN film_inventory ON rental.inventory_id=film_inventory.inventory_id 
      WHERE MONTHNAME(rental_date)=month_input;
  END$

--
-- Stored procedure for the incomes from series
--

CREATE PROCEDURE series_incomes(IN month_input VARCHAR(10))
  BEGIN
      SET @month=month_input;
      SELECT SUM(amount) FROM payment 
      INNER JOIN rental ON payment.rental_id=rental.rental_id 
      INNER JOIN series_inventory ON rental.inventory_id=series_inventory.inventory_id 
      WHERE MONTHNAME(rental_date)=month_input;
  END$

--
-- Stored Procedure for finding names
--

CREATE PROCEDURE find_name (IN lastName1 VARCHAR(45), IN lastName2 VARCHAR(45))
  BEGIN
    DECLARE actor_Lname1 VARCHAR(45);
    DECLARE actor_Lname2 VARCHAR(45);
    DECLARE sqlcommand VARCHAR(1000);
    DECLARE columList VARCHAR(75);
    SET @columList='last_name,first_name';
    SET @actor_Lname1=lastName1;
    SET @actor_Lname2=lastName2;
    SET @sqlcommand= CONCAT('SELECT ',@columList, ' FROM actor WHERE last_name > ''',@actor_Lname1,''';');
    PREPARE stmt FROM @sqlcommand;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    SELECT last_name, first_name FROM actor WHERE last_name LIKE CONCAT (@actor_lname1,'%') ORDER BY first_name ASC;
    SELECT last_name, first_name FROM actor WHERE last_name LIKE CONCAT (@actor_lname2,'%') ORDER BY first_name ASC;
  END$

--
-- Stored Procedure for finding actors with the same last name
--

CREATE PROCEDURE same_names(IN last_nameIN VARCHAR(45))
  BEGIN
    DECLARE not_found INT;
    DECLARE lastName VARCHAR(45);
    DECLARE firstName VARCHAR(45);
    DECLARE num INT;
    DECLARE nameCursor CURSOR FOR SELECT last_name, first_name FROM actor WHERE last_name=last_nameIN;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET not_found=1;
    SET num=0;
    OPEN nameCursor;
    SET not_found=0;
    REPEAT
      FETCH nameCursor INTO firstName,lastName;
      IF(not_found=0)THEN
        SELECT lastName AS 'Last Name' , firstName AS 'First Name';
        SET num=num+1;
      END IF;
      UNTIL(not_found=1)
    END REPEAT;
    SELECT num;
    CLOSE nameCursor;
  END$

--
-- Stored Procedure for finding the most viewed films/series
--

CREATE PROCEDURE top (IN ms CHAR(1), IN ar INT,IN date1 DATE,IN date2 DATE)
  BEGIN

   IF (ms='m') THEN
     
     SELECT film.film_id,title,COUNT(rental_id) AS 'RENTAL' FROM film
     INNER JOIN film_inventory ON film.film_id=film_inventory.film_id
     INNER JOIN rental ON film_inventory.inventory_id=rental.inventory_id
     WHERE rental_date>=date1 AND rental_date<=date2 GROUP BY film.film_id ORDER BY RENTAL DESC LIMIT ar ;

  ELSE 

     SELECT series_id,title,COUNT (rental_id) AS 'Rental' FROM series
     INNER JOIN series_inventory ON series_inventory.series_id=series.series_id
     INNER JOIN rental ON rental.inventory_id=series_inventrory.inventory_id 
     WHERE rental_date>=date1 AND rental_date<=date2 GROUP BY series.series_id ORDER BY Rental DESC LIMIT ar;
 END IF;
 END $
DELIMITER ;

--
-- Stored Procedure for rentals in a day
--

CREATE PROCEDURE rentals_in_date(IN email VARCHAR(50), IN date DATE, OUT rentals INT(5))
 BEGIN
  SELECT COUNT(rental.customer_id) INTO rentals FROM rental 
  INNER JOIN customer ON rental.customer_id=customer.customer_id 
  WHERE customer.email=email AND date=DATE(rental_date) GROUP BY rental.customer_id;
 END$
   

--
-- Trigger structure 1
--


CREATE TRIGGER update_log 
 AFTER INSERT ON film_rental
 FOR EACH ROW 
 BEGIN
  DECLARE cid SMALLINT(5);
  DECLARE rid INT(11);
  DECLARE currDate DATE;
  DECLARE usrnm VARCHAR(50);
  SET currDate= CURDATE();
  SELECT MAX(rental_id) INTO rid FROM rental;
  SELECT customer_id INTO cid FROM rental WHERE rental_id=rid;
  SELECT email INTO usrnm FROM customer where customer_id=cid;
  INSERT INTO log (username,user,movement,date,success,table_name)
  VALUES(usrnm,'C','INSERT',1,'Table Rental');
  END$

--
--
--

CREATE TRIGGER update_log_series 
 AFTER INSERT ON series_rental
 FOR EACH ROW 
 BEGIN
  DECLARE cid SMALLINT(5);
  DECLARE rid INT(11);
  DECLARE currDate DATE;
  DECLARE usrnm VARCHAR(50);
  SET currDate= CURDATE();
  SELECT MAX(rental_id) INTO rid FROM rental;
  SELECT customer_id INTO cid FROM rental WHERE rental_id=rid;
  SELECT email INTO usrnm FROM customer where customer_id=cid;
  INSERT INTO log (username,user,movement,date,success,table_name)
  VALUES(usrnm,'C','INSERT',1,'Table Rental');
  END$

--
--Trigger Structure for discount
--

CREATE TRIGGER discount
 BEFORE INSERT ON payment
 FOR EACH ROW
 BEGIN
  DECLARE rentals INT(5);
  DECLARE email VARCHAR(50);
  DECLARE currDate DATE;
  DECLARE cid SMALLINT(5);
  DECLARE rentid INT(11);
  DECLARE pid SMALLINT(5);
  DECLARE amount DECIMAL(5,2);
  DECLARE registration ENUM('M','S','MS');
  SELECT customer.registration INTO registration FROM customer WHERE NEW.customer.customer_id=customer.cuastomer_id;
  SELECT MAX(payment_id) INTO pid FROM payment;
  SET cid=NEW.customer_id;
  SET rentid=NEW.rental_id; 
  SET currDate=CURDATE();
  SET pid=pid+1;
  SELECT email INTO email FROM customer WHERE NEW.rental.customer_id=customer.customer_id;
  CALL rentals_in_date(email,currDate,rentals);
  IF(registration='M')THEN
   SET amount=0.4;
   IF(rentals>=3)THEN
    SET amount=amount-0.5*amount;
    INSERT INTO payment(payment_id,customer_id,rental_id,amount,payment_date)
    VALUES(pid,cid,rentid,amount,currDate);
   ELSE
    INSERT INTO payment(payment_id,customer_id,rental_id,amount,payment_date)
    VALUES(pid,cid,rentid,amount,currDate);
   END IF;
  ELSEIF(registration='MS')THEN
   SET amount=0.3;
   IF(rentals>=3)THEN
    SET amount=amount-0.5*amount;
    INSERT INTO payment(payment_id,customer_id,rental_id,amount,payment_date)
    VALUES(pid,cid,rentid,amount,currDate);
   ELSE
    INSERT INTO payment(payment_id,customer_id,rental_id,amount,payment_date)
    VALUES(pid,cid,rentid,amount,currDate);
   END IF;
  END IF;
 END$
  
--
--
--

CREATE TRIGGER series_discount
 BEFORE INSERT ON series_payment
 FOR EACH ROW
 BEGIN
  DECLARE rentals INT(5);
  DECLARE email VARCHAR(50);
  DECLARE currDate DATE;
  DECLARE cid SMALLINT(5);
  DECLARE rentid INT(11);
  DECLARE pid SMALLINT(5);
  DECLARE amount DECIMAL(5,2);
  DECLARE registration ENUM('M','S','MS');
  SELECT customer.registration INTO registration FROM customer WHERE NEW.customer.customer_id=customer.cuastomer_id;
  SELECT MAX(payment_id) INTO pid FROM payment;
  SET cid=NEW.customer_id;
  SET rentid=NEW.rental_id; 
  SET currDate=CURDATE();
  SET pid=pid+1;
  SELECT email INTO email FROM customer WHERE NEW.rental.customer_id=customer.customer_id;
  CALL rentals_in_date(email,currDate,rentals);
  IF(registration='S')THEN
   SET amount=0.2;
   IF(rentals>=3)THEN
    SET amount=amount-0.5*amount;
    INSERT INTO payment(payment_id,customer_id,rental_id,amount,payment_date)
    VALUES(pid,cid,rentid,amount,currDate);
   ELSE
    INSERT INTO payment(payment_id,customer_id,rental_id,amount,payment_date)
    VALUES(pid,cid,rentid,amount,currDate);
   END IF;
  ELSEIF(registration='MS')THEN
   SET amount=0.1;
   IF(rentals>=3)THEN
    SET amount=amount-0.5*amount;
    INSERT INTO payment(payment_id,customer_id,rental_id,amount,payment_date)
    VALUES(pid,cid,rentid,amount,currDate);
   ELSE
    INSERT INTO payment(payment_id,customer_id,rental_id,amount,payment_date)
    VALUES(pid,cid,rentid,amount,currDate);
   END IF;
  END IF;
 END$

--
--
--

CREATE TRIGGER do_not_do_that
 BEFORE UPDATE ON customer
 FOR EACH ROW
 BEGIN
 IF(NEW.email<>OLD.email)THEN 
  SIGNAL SQLSTATE VALUE '45000'
  SET MESSAGE_TEXT = 'You can not change your email!';
 END IF;
END$
  




  
  
