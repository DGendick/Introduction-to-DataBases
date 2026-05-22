--##############################################--
--------------ЛАБОРАТОРНАЯ РАБОТА №5--------------
--##############################################--

-- 1 Отображает все столбцы в таблице aircrafts --
select * from bookings.aircrafts_data;

-- 2 Отображает только выбранные столбцы в таблице aircrafts --
select aircraft_code, 
		model
from bookings.aircrafts_data;

-- 3 Получение конкретных строк в таблице --
select model, range
	from bookings.aircrafts_data  where range < 5000;

-- 4 Фильтрация данных с помощью сравнения строк --
select book_ref,passenger_id, passenger_name
	from bookings.tickets
	where passenger_name like 'V%' or passenger_name like 'E%';

-- 5 Получение диапазона значений --
select flight_no, scheduled_departure, scheduled_arrival,
		departure_airport, arrival_airport
		from bookings.flights
		where departure_airport = 'DME'
		AND scheduled_departure between '2017-08-31' and '2017-09-01';


-- 6 Получение списка значений --
select flight_no, scheduled_departure, scheduled_arrival,
		departure_airport, arrival_airport
		from bookings.flights
		where departure_airport = 'DME' and arrival_airport in ('LED','KZN')
		AND scheduled_departure between '2017-08-31' and '2017-09-01';

-- 7 Работа со значениями --
select flight_no, scheduled_departure, scheduled_arrival,
		actual_departure, actual_arrival
		from bookings.flights
		where departure_airport = 'DME'
		AND actual_departure is NULL;

select flight_no, scheduled_departure, scheduled_arrival,
	coalesce(actual_departure, '9999-12-31'),
	coalesce(actual_arrival, '9999-12-31')
	from bookings.flights
	where departure_airport = 'DME'
	and arrival_airport  = 'KZN';

select flight_no, scheduled_departure, scheduled_arrival,
	coalesce(actual_departure, '9999-12-31') AS "Actual Departure",
	coalesce(actual_arrival, '9999-12-31') AS "Actual Arrival"
	from bookings.flights
	where departure_airport = 'DME'
	and arrival_airport  = 'KZN';

select scheduled_departure,flight_no,
	coalesce (actual_departure::varchar,'CANCELED') as "Actual Departure"
	from bookings.flights
	where departure_airport = 'DME'
	and arrival_airport  = 'KZN';

-- 8 Сортировка данных --
select scheduled_departure,flight_no, departure_airport, arrival_airport
	from bookings.flights
	where departure_airport = 'DME'
	order by arrival_airport;

select scheduled_departure,flight_no, departure_airport, arrival_airport
	from bookings.flights
	where departure_airport = 'DME'
	order by arrival_airport, scheduled_departure desc;	

-- 9 Устранение дублирования строк --
select distinct departure_airport, arrival_airport
	from bookings.flights
	order by 1, 2;
	
-- 10 Использование выражений --
select scheduled_departure,
	'from: ' ||departure_airport::varchar|| ' to: '
			||arrival_airport::varchar AS destination,
	status
	from bookings.flights;

select book_ref,
	substring(passenger_name from 1 for position(' ' in passenger_name)) as name,
	substring(passenger_name from position(' ' in passenger_name)) as surname
	from bookings.tickets;
-- 11 Агрегатные функции --
select avg(amount) as average,
		sum(amount) as summary
		from bookings.ticket_flights
		where fare_conditions = 'Economy';	

select
	count (*)
	from bookings.ticket_flights
	where fare_conditions = 'Economy';

-- 12. Использование Агрегатных функций с NULL --
select 
	count (*)
	from bookings.flights
	where coalesce (actual_arrival::date,'2017-06-12') = '2017-06-12';

select
	count (actual_arrival)
	from bookings.flights
	where coalesce (actual_arrival::date,'2017-06-12') = '2017-06-12';

select 
	count(distinct departure_airport)
from bookings.flights;

-- 13. Подведение итогов --
select
	departure_airport,
	count (arrival_airport)
	from bookings.flights
	group by departure_airport; -- без этой строки работать не будет т.к. необходим критерий группировки расчетов

-- 14. Подведение итогов --
select
	departure_airport,
	count (arrival_airport)
	from bookings.flights
	group by departure_airport;

-- 15. Использование предложения HAVING --
select
	departure_airport,
	count (arrival_airport)
	from bookings.flights
	group by departure_airport
	having count (actual_arrival) < 50;

-- 16. Как работают операторы ROLLUP и CUBE --
select 
	departure_airport,
	arrival_airport,
	count (arrival_airport)
	from bookings.flights
	group by rollup (departure_airport,arrival_airport)   
	having count (actual_arrival) > 300;

select 
	departure_airport,
	arrival_airport,
	count (arrival_airport)
	from bookings.flights
	group by cube (departure_airport,arrival_airport)   
	having count (actual_arrival) > 300;