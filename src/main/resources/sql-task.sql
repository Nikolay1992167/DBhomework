1. SELECT model->> 'ru' AS model_ru,
          fare_conditions,
          count(seat_no) AS quantity_of_seats
   FROM aircrafts_data
            JOIN seats ON aircrafts_data.aircraft_code = seats.aircraft_code
   GROUP BY model, fare_conditions
   ORDER BY model;

2.SELECT model ->> 'ru' AS model,
         count(seat_no) AS quantity_of_seats
  FROM aircrafts_data AS ad
           JOIN seats ON ad.aircraft_code = seats.aircraft_code
  GROUP BY ad.aircraft_code
  ORDER BY quantity_of_seats DESC
  LIMIT 3;

3. SELECT flight_id, flight_no, scheduled_departure, actual_departure
   FROM flights
   WHERE (actual_departure - scheduled_departure) > INTERVAL '2 hours';

4. SELECT tickets.passenger_name, tickets.contact_data
   FROM tickets
   JOIN ticket_flights ON tickets.ticket_no = ticket_flights.ticket_no
   WHERE ticket_flights.fare_conditions = 'Business'
   ORDER BY tickets.ticket_no DESC
   LIMIT 10;

5. SELECT f.flight_id, f.flight_no
   FROM flights AS f
   LEFT JOIN ticket_flights AS tf ON f.flight_id = tf.flight_id
       AND tf.fare_conditions = 'Business'
   WHERE tf.ticket_no IS NULL;

6. SELECT DISTINCT ad.airport_name, ad.city
   FROM airports_data AS ad
   JOIN flights AS f ON (ad.airport_code = f.departure_airport OR ad.airport_code = f.arrival_airport)
   WHERE (f.actual_departure > f.scheduled_departure) OR (f.actual_arrival > f.scheduled_arrival);

7. SELECT ad.airport_name ->> 'ru', COUNT(f.flight_id) AS number_flights
   FROM airports_data AS ad
   JOIN flights AS f ON ad.airport_code = f.departure_airport
   GROUP BY ad.airport_name
   ORDER BY number_flights DESC;

8. SELECT *
   FROM flights AS f
   WHERE (f.scheduled_arrival != f.actual_arrival);

9. SELECT ad.aircraft_code,
          model ->> 'ru' AS model_aircraft,
          seat_no
   FROM aircrafts_data AS ad
            JOIN seats AS s ON ad.aircraft_code = s.aircraft_code
   WHERE model ->> 'ru' = 'Аэробус A321-200'
     AND fare_conditions != 'Economy'
   ORDER BY seat_no;

10. SELECT airport_code,
           airport_name ->> 'ru' AS name,
           city ->> 'ru'         AS city
    FROM airports_data
    WHERE city IN (SELECT city
                   FROM airports_data
                   GROUP BY city
                   HAVING count(*) > 1)
    ORDER BY city;

11.