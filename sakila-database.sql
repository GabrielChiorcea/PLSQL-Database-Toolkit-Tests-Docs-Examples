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


#Exercițiul 16: Găsește clienții care au cheltuit cei mai mulți bani într-o singură închiriere
#Afișează clienții care au efectuat cea mai mare plată într-o singură închiriere.
SELECT 
    CONCAT(customer.first_name, ' ', customer.last_name) AS full_name, 
    payment.amount, 
    payment.payment_date 
FROM 
    payment
JOIN 
    rental ON payment.rental_id = rental.rental_id
JOIN 
    customer ON payment.customer_id = customer.customer_id 
ORDER BY 
    payment.amount DESC
LIMIT 10;

#or

SELECT  
    customer.customer_id, 
    SUM(payment.amount) AS total_amount, 
    DATE(payment.payment_date) AS payment_day
FROM 
    payment
JOIN 
    customer ON payment.customer_id = customer.customer_id
where customer.customer_id = 21
GROUP BY 
    customer.customer_id, payment_day
ORDER BY 
    total_amount DESC;


#Exercițiul 17: Găsește categoriile de filme care generează cele mai mari încasări
#Afișează categoriile de filme și suma totală a încasărilor generate de acestea, ordonate descrescător după încasări.
select  
	category.name as category, 
	count(rental.rental_id) as rentals, 
    sum(payment.amount) as total, 
    year(rental.rental_date) as rental_year # doar ca sa vad pe ani
FROM 
    payment
JOIN rental ON payment.rental_id = rental.rental_id
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON inventory.film_id = film.film_id
JOIN film_category ON film.film_id = film_category.film_id
JOIN category ON film_category.category_id = category.category_id 
group by 
	category, rental_year 
order by 
	category;

#Exercițiul 18: Găsește orașele cu cele mai multe închirieri
#Afișează orașele și numărul total de închirieri pentru fiecare oraș, ordonat descrescător după numărul de închirieri.
SELECT 
    city.city AS city_name, 
    COUNT(rental.rental_id) AS total_rentals
FROM 
    rental
JOIN 
    customer ON rental.customer_id = customer.customer_id
JOIN 
    address ON customer.address_id = address.address_id
JOIN 
    city ON address.city_id = city.city_id
JOIN 
    country ON city.country_id = country.country_id
GROUP BY 
    city.city 
ORDER BY 
    total_rentals DESC;  -- Ordonează descrescător după numărul total de închirieri

#Exercițiul 19: Găsește lunile cu cele mai multe închirieri
#Afișează numărul total de închirieri pentru fiecare lună din baza de date, ordonat descrescător după numărul de închirieri.
SELECT     
    YEAR(rental.rental_date) AS rental_year,
    MONTH(rental.rental_date) AS rental_month,
    COUNT(rental.rental_id) AS rentals
FROM 
    rental
JOIN 
    inventory ON rental.inventory_id = inventory.inventory_id
JOIN 
    film ON inventory.film_id = film.film_id
GROUP BY 
    rental_year, rental_month 
ORDER BY 
    rentals DESC; 

#Exercițiul 20: Găsește filmele care au fost închiriate de către cei mai mulți clienți diferiți
#Afișează filmele împreună cu numărul de clienți unici care le-au închiriat.
SELECT 
    film.title,
    COUNT(DISTINCT rental.customer_id) AS unique_customers
FROM 
    rental
JOIN 
    inventory ON rental.inventory_id = inventory.inventory_id
JOIN 
    film ON inventory.film_id = film.film_id
JOIN 
    customer ON rental.customer_id = customer.customer_id
GROUP BY     
    film.title 
ORDER BY 
    unique_customers DESC;


#Exercițiul 21: Găsește clienții care au închiriat toate filmele dintr-o anumită categorie
#Afișează clienții care au închiriat fiecare film dintr-o categorie specifică (de exemplu, "Action").
SELECT 
    customer.customer_id, 
    customer.first_name, 
    customer.last_name
FROM 
    rental
JOIN 
    inventory ON rental.inventory_id = inventory.inventory_id
JOIN 
    film ON inventory.film_id = film.film_id
JOIN 
    film_category ON film.film_id = film_category.film_id
JOIN 
    category ON film_category.category_id = category.category_id
JOIN 
    customer ON rental.customer_id = customer.customer_id
WHERE 
    category.name = 'Action'
GROUP BY 
    customer.customer_id
HAVING 
    COUNT(DISTINCT film.film_id) = (
        SELECT COUNT(film.film_id) 
        FROM film 
        JOIN film_category ON film.film_id = film_category.film_id
        JOIN category ON film_category.category_id = category.category_id
        WHERE 
            category.name = 'Action'
    )
ORDER BY 
    customer.customer_id DESC;


#Write a query to display information of Films that have maximum number of renting days for the Films that have the length
#of is greater than or equals to 180. Order by film_id as ascending. 
SELECT film_id, title, rental_duration
FROM film
WHERE length >= 180
ORDER BY rental_duration DESC, film_id ASC;

#Write a query to display number of actors for the films that have length >= 185. Order by number of actors as ascending.
SELECT 
    film.title AS title, 
    COUNT(actor.actor_id) AS actors
FROM 
    film_actor fa
JOIN 
    film ON fa.film_id = film.film_id
JOIN 
    actor ON fa.actor_id = actor.actor_id
WHERE 
    film.length >= 185
GROUP BY 
    film.title
ORDER BY 
    actors ASC;

#Write a query to display the total payment (total payment is calculated by sum up all amounts in Payment table) and number of renting 
#times of films for all customers who have number of renting times is greater than or 
#equals to 40. Order by number of renting as ascending
SELECT 
    customer.customer_id, 
    SUM(payment.amount) AS total_payment, 
    COUNT(rental.rental_id) AS renting_times
FROM 
    customer
JOIN 
    rental ON customer.customer_id = rental.customer_id
JOIN 
    payment ON rental.rental_id = payment.rental_id
GROUP BY 
    customer.customer_id
HAVING 
    COUNT(rental.rental_id) >= 40
ORDER BY 
    renting_times ASC;

#Find out the top 5 countries with most number of customers. Order by number of customer as ascending.
SELECT 
    country.country as country, count(customer.customer_id)  as total_customer
FROM 
    customer
JOIN 
    address ON customer.address_id = address.address_id
JOIN 
    city ON address.city_id = city.city_id
JOIN 
    country ON city.country_id = country.country_id 
group by country
order by total_customer desc
    limit 5;

#Write a query to display the number of film for each category. Order by number of film as ascending.
SELECT 
    category.name as category, 
    COUNT(film.film_id) as total_film
FROM 
    film
JOIN 
    film_category ON film.film_id = film_category.film_id
JOIN 
    category ON film_category.category_id = category.category_id
GROUP BY 
    category.name
ORDER BY 
    category.name ASC;

