use sakila;

-- 1. Escribe una consulta para mostrar para cada tienda su ID de tienda, ciudad y país.

select store_id, c.city, d.country
from store a
inner join address b
on a.address_id = b.address_id
inner join city c
on b.city_id = c.city_id
inner join country d 
on c.country_id = d.country_id;

-- 2. Escribe una consulta para mostrar cuánto negocio, en dólares, trajo cada tienda.

with store_address_cte as (select store_id, c.city, d.country
from store a
inner join address b
on a.address_id = b.address_id
inner join city c
on b.city_id = c.city_id
inner join country d 
on c.country_id = d.country_id)

select st.store_id, concat(city, ',', ' ', country) as Store_Location, sum(amount) as amount
from store_address_cte st

inner join inventory inv
on st.store_id = inv.store_id
inner join rental rt
on inv.inventory_id = rt.inventory_id
inner join payment pm
on rt.rental_id = pm.rental_id
group by st.store_id, Store_Location;

-- ¿Cuál es el tiempo de ejecución promedio de las películas por categoría?

select ct.name as category, avg(length) as avg_ejecucion
from film f
inner join film_category fc
on f.film_id = fc.film_id
inner join category ct
on fc.category_id = ct.category_id
group by category;

-- ¿Qué categorías de películas son las más largas?
select ct.name as category, avg(length) as avg_ejecucion
from film f
inner join film_category fc
on f.film_id = fc.film_id
inner join category ct
on fc.category_id = ct.category_id
group by category
order by avg_ejecucion DESC
limit 3;

-- Muestra las películas más alquiladas en orden descendente.
select title, count(distinct(rental_id)) as rentals
from film a
inner join inventory b
on a.film_id = b.film_id
inner join rental c
on b.inventory_id = c.inventory_id
group by title
order by rentals DESC;

-- Enumera los cinco principales géneros en ingresos brutos en orden descendente.
select ct.name as category, sum(amount)
from film f
inner join film_category fc
on f.film_id = fc.film_id
inner join category ct
on fc.category_id = ct.category_id
inner join inventory b
on f.film_id = b.film_id
inner join rental c
on b.inventory_id = c.inventory_id
inner join payment d
on c.rental_id = d.rental_id

group by category
order by sum(amount) desc
limit 5;

-- ¿Está "Academy Dinosaur" disponible para alquilar en la Tienda 1?

select distinct d.store_id, title, c.inventory_id, case when return_date < c.last_update then 'Available'
else 'Not available'
end as Availability
from film a
inner join inventory b
on a.film_id = b.film_id
inner join rental c
on b.inventory_id = c.inventory_id
inner join store d
on d.store_id = b.store_id
where title = 'Academy Dinosaur' and d.store_id = 1;

