-- DROP AND CREATE DATABASE
DROP DATABASE IF EXISTS travelonthego;

CREATE DATABASE IF NOT EXISTS travelonthego;

USE travelonthego;

-- DROP AND CREATE TABLES
DROP TABLE IF EXISTS passenger;

DROP TABLE IF EXISTS price;

CREATE TABLE IF NOT EXISTS price
  (
     price_id INT auto_increment,
     bus_type VARCHAR(50) NOT NULL,
     distance BIGINT NOT NULL,
     price    DOUBLE NOT NULL,
     PRIMARY KEY(price_id)
  );

CREATE TABLE passenger
  (
     passenger_id     INT auto_increment,
     passenger_name   VARCHAR(50) NOT NULL,
     category         VARCHAR(50) NOT NULL,
     gender           VARCHAR(1) NOT NULL,
     boarding_city    VARCHAR(50) NOT NULL,
     destination_city VARCHAR(20) NOT NULL,
     price_id         INT NOT NULL,
     PRIMARY KEY(passenger_id),
     FOREIGN KEY (price_id) REFERENCES price (price_id)
  );

-- INSERT VALUES
INSERT INTO price
            (bus_type,
             distance,
             price)
VALUES      ('Sleeper',
             350,
             770),
            ('Sleeper',
             500,
             1100),
            ('Sleeper',
             600,
             1320),
            ('Sleeper',
             700,
             1540),
            ('Sleeper',
             1000,
             2200),
            ('Sleeper',
             1200,
             2640),
            ('Sleeper',
             1500,
             2700),
            ('Sitting',
             500,
             620),
            ('Sitting',
             600,
             744),
            ('Sitting',
             700,
             868),
            ('Sitting',
             1000,
             1240),
            ('Sitting',
             1200,
             1488),
            ('Sitting',
             1500,
             1860);



INSERT INTO passenger
            (passenger_name,
             category,
             gender,
             boarding_city,
             destination_city,
             price_id)
VALUES      ('Sejal',
             'AC',
             'F',
             'Bengaluru',
             'Chennai',
             1),
            ('Anmol',
             'Non-AC',
             'M',
             'Mumbai',
             'Hyderabad',
             10),
            ('Pallavi',
             'AC',
             'F',
             'Panaji',
             'Bengaluru',
             3),
            ('Khusboo',
             'AC',
             'F',
             'Chennai',
             'Mumbai',
             7),
            ('Udit',
             'Non-AC',
             'M',
             'Trivandrum',
             'Panaji',
             5),
            ('Ankur',
             'AC',
             'M',
             'Nagpur',
             'Hyderabad',
             8),
            ('Hemant',
             'Non-AC',
             'M',
             'panaji',
             'Mumbai',
             4),
            ('Manish',
             'Non-AC',
             'M',
             'Hyderabad',
             'Bengaluru',
             8),
            ('Piyush',
             'AC',
             'M',
             'Pune',
             'Nagpur',
             10);


-- Query 3
SELECT
  COUNT(psgr.passenger_id) AS passenger_count,
  psgr.gender
FROM passenger psgr
INNER JOIN price pr
  ON pr.price_id = psgr.price_id
WHERE pr.distance >= 600
GROUP BY psgr.gender;

-- Query 4
SELECT Min(price) as sleeper_min_fare
FROM   price
WHERE  bus_type = "Sleeper";

-- Query 5
SELECT passenger_name
FROM   passenger
WHERE  UPPER(passenger_name) LIKE "S%";

-- Query 6
SELECT psgr.passenger_name,
       psgr.boarding_city,
       psgr.destination_city,
       pr.bus_type,
       pr.price
FROM   passenger psgr
       INNER JOIN price pr
               ON pr.price_id = psgr.price_id;

-- Query 7
SELECT psgr.passenger_name,
       pr.price
FROM   passenger psgr
       INNER JOIN price pr
               ON pr.price_id = psgr.price_id
WHERE  pr.price_id = "Sitting"
       AND pr.distance = 1000;

-- Query 8
SELECT pr.bus_type,
       pr.price
FROM   price pr
       INNER JOIN passenger psgr
               ON psgr.price_id = pr.price_id
WHERE  ( ( psgr.boarding_city = 'Bengaluru'
           AND psgr.destination_city = 'Panaji' )
          OR ( psgr.boarding_city = 'Panaji'
               AND psgr.destination_city = 'Bengaluru' ) )
       AND psgr.passenger_name = "Pallavi";

-- Query 9
SELECT DISTINCT pr.distance
FROM   price pr
       INNER JOIN passenger psgr
               ON psgr.price_id = pr.price_id
ORDER  BY pr.distance DESC;

-- Query 10
SELECT passenger.passenger_name,
       Concat(Round(( ( price.distance / (SELECT Sum(price.distance)
                                          FROM   price
                                                 INNER JOIN passenger
                                                         ON passenger.price_id =
                                                            price.price_id) ) *
                                   100 ), 2), '%') AS per_distance_travelled
FROM   passenger
       INNER JOIN price
               ON price.price_id = passenger.price_id;

-- Query 11
SELECT distance,
       price,
       ( CASE
           WHEN price > 1000 THEN "Expensive"
           WHEN price > 500
                AND price < 1000 THEN "Average Cost"
           ELSE "Cheap"
         end ) AS category
FROM   price