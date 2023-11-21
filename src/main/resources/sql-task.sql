1. SELECT model->> 'ru' AS model_ru,
          fare_conditions,
          count(seat_no) AS quantity_of_seats
   FROM aircrafts_data
            JOIN seats ON aircrafts_data.aircraft_code = seats.aircraft_code
   GROUP BY model, fare_conditions
   ORDER BY model;

2.SELECT model ->> 'ru' AS model,
         count(seat_no) AS quantity_of_seats
  FROM aircrafts_data
           JOIN seats ON aircrafts_data.aircraft_code = seats.aircraft_code
  GROUP BY aircrafts_data.aircraft_code
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