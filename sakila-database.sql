Use sakila;
#1. Alăturări multiple și subinterogări complexe


#Exercițiul 1: Găsește numele filmelor care au fost închiriate de clienți care locuiesc în orașul „London”.
select film.title, rental.customer_id, inventory.inventory_id from rental  join inventory on rental.inventory_id = inventory.inventory_id  join film 
on inventory.film_id = film.film_id where rental.customer_id in (
		select customer_id from customer right join address on customer.customer_id = address.address_id right join 
		city on address.address_id = city.city_id where city = 'London'
);


#Exercițiul 2: Găsește numele actorilor care au jucat în filme din categoria „Horror”, dar care nu au jucat în filme din categoria „Comedy”.
SELECT DISTINCT a.first_name, a.last_name
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Horror'
AND a.actor_id NOT IN (
    SELECT a2.actor_id
    FROM actor a2
    JOIN film_actor fa2 ON a2.actor_id = fa2.actor_id
    JOIN film f2 ON fa2.film_id = f2.film_id
    JOIN film_category fc2 ON f2.film_id = fc2.film_id
    JOIN category c2 ON fc2.category_id = c2.category_id
    WHERE c2.name = 'Comedy'
);

#exercițiul 3: Găsește filmele care nu au fost niciodată închiriate
select film.title from film where film.film_id not in ( 
SELECT DISTINCT inventory.film_id
    FROM rental
    JOIN inventory ON rental.inventory_id = inventory.inventory_id
) ;

#Exercițiul 4: Găsește toate filmele în care joacă mai mult de 3 actori.
select  count(actor.first_name) as actors, film.title  from film_actor as fa join film on fa.film_id = film.film_id join actor on fa.actor_id = actor.actor_id 
 group by film.title HAVING COUNT(actor.actor_id) > 3 ORDER BY actors ASC ;
 
 
#2. Funcții agregate și interogări cu grupare 


#Exercițiul 5: Găsește primele 5 filme cu cele mai mari încasări totale din închirieri.
select sum(payment.amount), film.title from rental join payment on rental.rental_id = payment.rental_id join inventory on rental.inventory_id = inventory.inventory_id join 
film on inventory.film_id = film.film_id   group by film.title order by sum(payment.amount) desc limit 5;
 
#Exercițiul 6: Găsește categoria de filme cu cel mai mare număr total de închirieri.
SELECT category.name, COUNT(rental.rental_id) AS total_rentals
FROM rental
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film_category AS fc ON inventory.film_id = fc.film_id
JOIN category ON fc.category_id = category.category_id
GROUP BY category.name
ORDER BY total_rentals DESC
LIMIT 1;

#Exercițiul 7: Găsește orașul cu cele mai multe închirieri și numărul total de închirieri din acel oraș.
SELECT city.city AS city, COUNT(rental.rental_id) AS rentals_nr
FROM rental
JOIN customer ON rental.customer_id = customer.customer_id
JOIN address ON customer.address_id = address.address_id
JOIN city ON address.city_id = city.city_id
GROUP BY city.city
ORDER BY rentals_nr DESC
LIMIT 1;

#Exercițiul 8: Găsește clienții care au cheltuit în medie cei mai mulți bani pe închirieri.
SELECT 
    CONCAT(customer.first_name, ' ', customer.last_name) AS name, 
    ROUND(AVG(payment.amount), 1) AS average_spent
FROM 
    payment
JOIN customer ON payment.customer_id = customer.customer_id
GROUP BY customer.customer_id
ORDER BY average_spent DESC
LIMIT 10;

#3. Manipularea datelor și interogări avansate
#Exercițiul 9: Actualizează prețul de închiriere pentru toate filmele din categoria „Drama”, crescându-l cu 10%.

#Exercițiul 10: Șterge toate înregistrările de închiriere care sunt mai vechi de 5 ani din tabelul rental.
#DELETE FROM rental
#WHERE rental_date < NOW() - INTERVAL 5 YEAR;

#Exercițiul 11: Creează un raport care să includă numele filmului, numele actorilor din acel film și numărul de închirieri ale filmului, ordonat descrescător după numărul de închirieri.
SELECT 
    film.title, 
    GROUP_CONCAT(DISTINCT CONCAT(actor.first_name, ' ', actor.last_name) SEPARATOR "; ") AS actors, 
    COUNT(rental.rental_id) AS "rental times" 
FROM 
    film
JOIN 
    film_actor AS fa ON film.film_id = fa.film_id
JOIN 
    actor ON fa.actor_id = actor.actor_id
JOIN 
    inventory ON film.film_id = inventory.film_id
JOIN 
    rental ON inventory.inventory_id = rental.inventory_id 
GROUP BY 
    film.title
ORDER BY 
    `rental times` DESC;


#Exercițiul 12: Găsește cei mai activi clienți care au închiriat filme de cel puțin 3 ori pe lună, în medie, în ultimul an.
SELECT 
    CONCAT(customer.first_name, ' ', customer.last_name) AS full_name,
    COUNT(rental.rental_id) AS total_rentals,
    ROUND(COUNT(rental.rental_id) / 12, 2) AS avg_rentals_per_month
FROM 
    rental
JOIN 
    customer ON rental.customer_id = customer.customer_id
WHERE 
    rental.rental_date >= NOW() - INTERVAL 5 YEAR  -- Include închirierile din ultimul an
GROUP BY 
    full_name
HAVING 
    avg_rentals_per_month >= 3  -- Filtrare după medie
ORDER BY 
    avg_rentals_per_month DESC;  -- Ordonare descrescătoare


#4. Interogări avansate cu ferestre (window functions)
#Exercițiul 13: Creează o interogare care să afișeze numărul cumulativ de închirieri pentru fiecare lună din ultimul an, pentru fiecare client în parte.
select 
 CONCAT(customer.first_name, ' ', customer.last_name) AS full_name,
 count(rental.rental_id),
 month(rental.rental_date) as rental_date,
 Sum(payment.amount) over (partition by customer.customer_id order by  month(rental.rental_date)) as pay
 # SUM(payment.amount) OVER (PARTITION BY customer_id ORDER BY rental_date)
 from 
  rental
 JOIN 
    customer ON rental.customer_id = customer.customer_id
    JOIN 
    payment ON rental.rental_id = payment.rental_id
where year(rental.rental_date) = 2006
group by full_name, rental_date;

SELECT 
    CONCAT(customer.first_name, ' ', customer.last_name) AS full_name,
    MONTH(rental.rental_date) AS rental_month,
    YEAR(rental.rental_date) AS rental_year,
    COUNT(*) AS total_rentals,  -- numără închirierile
    SUM(COUNT(*)) OVER (PARTITION BY customer.customer_id ORDER BY MONTH(rental.rental_date)) AS cumulative_rentals
FROM 
    rental
JOIN 
    customer ON rental.customer_id = customer.customer_id
WHERE 
    YEAR(rental.rental_date) = 2006
GROUP BY 
    customer.customer_id, full_name, rental_month, rental_year  -- include customer.customer_id
ORDER BY 
    rental_year, rental_month;
    
#Exercițiul 14: Afișează toate filmele cu durate peste media duratei tuturor filmelor din baza de date, ordonat descrescător după durată.
SELECT title, length 
FROM film 
WHERE length > (SELECT AVG(length) FROM film) 
ORDER BY length DESC;


#Exercițiul 15: Găsește filmele care au fost închiriate cel mai frecvent în ultimele 6 luni, împreună cu numărul de închirieri și încasările generate.
 
WITH RentalCounts AS (
    SELECT 
        film.title, 
        COUNT(rental.rental_id) AS total,
        SUM(payment.amount) AS pay
    FROM 
        rental
    JOIN 
        payment ON rental.rental_id = payment.rental_id
    JOIN 
        inventory ON rental.inventory_id = inventory.inventory_id 
    JOIN 
        film ON inventory.film_id = film.film_id 
    WHERE 
        rental.return_date >= DATE_SUB('2006-01-01', INTERVAL 6 MONTH)
    GROUP BY 
        film.title 
    ORDER BY 
        total DESC
),

AverageRentals AS (
    SELECT 
        AVG(total) AS avg_rentals
    FROM 
        RentalCounts
)

SELECT 
    rc.title, 
    rc.total, 
    rc.pay
FROM 
    RentalCounts rc
JOIN 
    AverageRentals ar ON rc.total > ar.avg_rentals
ORDER BY 
    rc.total DESC;
