1. SELECT model->> 'ru' model_ru,
                        fare_conditions,
                        count(seat_no) quantity_of_seats
   FROM aircrafts_data ad
   JOIN seats s ON ad.aircraft_code = s.aircraft_code
   GROUP BY model,
            fare_conditions
   ORDER BY model;

2. SELECT model ->> 'ru' model,
                         count(seat_no) quantity_of_seats
   FROM aircrafts_data ad
   JOIN seats ON ad.aircraft_code = seats.aircraft_code
   GROUP BY ad.aircraft_code
   ORDER BY quantity_of_seats DESC
   LIMIT 3;

3. SELECT flight_id, flight_no, scheduled_departure, actual_departure
   FROM flights
   WHERE (actual_departure - scheduled_departure) > INTERVAL '2 hours';

4. SELECT t.passenger_name,
          t.contact_data
   FROM tickets t
   JOIN ticket_flights tf ON t.ticket_no = tf.ticket_no
   WHERE tf.fare_conditions = 'Business'
   ORDER BY t.ticket_no DESC
   LIMIT 10;

5. SELECT f.flight_id,
          f.flight_no
   FROM flights f
   LEFT JOIN ticket_flights tf ON f.flight_id = tf.flight_id
   AND tf.fare_conditions = 'Business'
   WHERE tf.ticket_no IS NULL;

6. SELECT DISTINCT ad.airport_name ->> 'ru' name_airport,
                                            ad.city ->> 'ru' name_city
   FROM airports_data ad
   JOIN flights f ON (ad.airport_code = f.departure_airport
                      OR ad.airport_code = f.arrival_airport)
   WHERE (f.actual_departure > f.scheduled_departure)
     OR (f.actual_arrival > f.scheduled_arrival);

7. SELECT ad.airport_name ->> 'ru',
                              COUNT(f.flight_id) number_flights
   FROM airports_data ad
   JOIN flights f ON ad.airport_code = f.departure_airport
   GROUP BY ad.airport_name
   ORDER BY number_flights DESC;

8. SELECT *
   FROM flights f
   WHERE (f.scheduled_arrival != f.actual_arrival);

9. SELECT ad.aircraft_code,
          model ->> 'ru' model_aircraft,
                         seat_no
   FROM aircrafts_data ad
   JOIN seats s ON ad.aircraft_code = s.aircraft_code
   WHERE model ->> 'ru' = 'Аэробус A321-200'
     AND fare_conditions != 'Economy'
   ORDER BY seat_no;

10. SELECT airport_code,
           airport_name ->> 'ru' airport_name,
                                 city ->> 'ru' city
    FROM airports_data
    WHERE city IN
        (SELECT city
         FROM airports_data
         GROUP BY city
         HAVING count(*) > 1)
    ORDER BY city;

11. SELECT t.passenger_id,
           t.passenger_name,
           SUM(b.total_amount) AS total_booking_amount
    FROM tickets t
    JOIN bookings b ON t.book_ref = b.book_ref
    GROUP BY t.passenger_id,
             t.passenger_name
    HAVING SUM(b.total_amount) >
      (SELECT AVG(total_amount)
       FROM bookings);

12. SELECT flight_id,
           ad.city ->> 'ru' AS departure,
                       adr.city ->> 'ru' AS arrival,
                                    status
    FROM flights f
    JOIN airports_data ad ON f.departure_airport = ad.airport_code
    JOIN airports_data adr ON f.arrival_airport = adr.airport_code
    WHERE ad.city ->> 'ru' = 'Екатеринбург'
      AND adr.city ->> 'ru' = 'Москва'
      AND f.status NOT IN ('Departed',
                           'Arrived',
                           'Cancelled')
      AND scheduled_departure > bookings.now()
    ORDER BY scheduled_departure
    LIMIT 1;

13. SELECT concat('Min #', min_tecket_no, ', price = ', min_amount) min_cost,
           concat('Max #', max_ticket_no, ', price = ', max_amount) max_cost
    FROM
      (SELECT ticket_no min_tecket_no,
              amount min_amount
       FROM ticket_flights
       ORDER BY amount
       LIMIT 1) AS MIN,

      (SELECT ticket_no max_ticket_no,
              amount max_amount
       FROM ticket_flights
       ORDER BY amount DESC
       LIMIT 1) AS MAX;

14. CREATE TABLE IF NOT EXISTS customers
    (
        id        UUID DEFAULT gen_random_uuid()  PRIMARY KEY,
        first_name VARCHAR(30) NOT NULL,
        last_name  VARCHAR(30) NOT NULL,
        email     VARCHAR(30) NOT NULL UNIQUE,
        phone     VARCHAR(20) NOT NULL
    );

    ALTER TABLE customers
        ADD CONSTRAINT first_name_check CHECK (first_name ~* '^[A-Za-z]+$'),
        ADD CONSTRAINT last_name_check CHECK (last_name ~* '^[A-Za-z]+$'),
        ADD CONSTRAINT email_check CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'),
        ADD CONSTRAINT phone_check CHECK (phone LIKE '+%');

15. CREATE TABLE IF NOT EXISTS orders
    (
        id         UUID DEFAULT gen_random_uuid()  PRIMARY KEY,
        customer_id UUID NOT NULL REFERENCES customers (id),
        quantity   INTEGER   NOT NULL
    );

    ALTER TABLE orders
        ADD CONSTRAINT quantity_check CHECK (quantity > 0);



16. INSERT INTO customers (first_name, last_name, email, phone)
        VALUE ('Ivan', 'Ivanov', 'ivanov@gmail.com', '+375291234567'),
              ('Petr', 'Petrov', 'petrov@gmail.com', '+375292345678'),
              ('Egor', 'Egorov', 'egorov@gmail.com', '+375293456789'),
              ('Sveta', 'Svetova', 'svetova@gmail.com', '+375294567891'),
              ('Fedor', 'Fedorov', 'fedorov@gmail.com', '+375295678912');

   INSERT INTO orders (customer_id, quantity)
        VALUE ('4578ec15-2bc3-47ab-adff-007dde79888c', '3'),
              ('692e7d42-c85a-48c3-adc8-526325a44b3d', '4'),
              ('1b093641-5fe2-47c0-affa-1e041b5b1e90', '2'),
              ('176bfab3-3e73-4980-b11e-b05fc6bc1f00', '1'),
              ('2b9d70f2-774c-409a-8fa2-b4cca5ed5553', '9');

17. DROP TABLE IF EXISTS customers, orders;