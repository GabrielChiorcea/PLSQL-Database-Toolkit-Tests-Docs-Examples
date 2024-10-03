Use sakila;

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
select  count(actor.first_name) as actors, film.title  from film_actor as fa join film on  fa.film_id = film.film_id join actor on fa.actor_id = actor.actor_id 
 group by film.title HAVING COUNT(actor.actor_id) > 3 ORDER BY actors ASC ;