Select * from app_store_apps
WHERE rating < 4.0
ORDER BY rating DESC;
Select * from play_store_apps;

Select name, rating
FROM app_store_apps
WHERE rating >2.1
ORDER BY name;

/* sample Select DISTINCT(a.name), 1+.5*a.rating*12 AS proj_ls, (1000*1+(.5*a.rating)*12) AS mkt_cost from app_store_apps AS a
INNER JOIN play_store_apps AS p
ON p.name = a.name
ORDER BY proj_ls DESC, a.name;

Select DISTINCT(a.name), a.price, p.price, a.rating, p.rating from app_store_apps AS a
INNER JOIN play_store_apps AS p
ON p.name = a.name
ORDER BY a.name;

ALTER TABLE app_store_apps
ADD COLUMN proj_ls; */

Select * FROM app_store_apps as a
INNER JOIN play_store_apps AS p
on p.name = a.name
ORDER BY a.price DESC;

/*Select DISTINCT(a.name), (1+.5*a.rating)*12 AS proj_ls, 1000*(1+.5*a.rating)*12 AS mkt_cost, 10000 * a.price AS purchase_price, a.price from app_store_apps AS a
INNER JOIN play_store_apps AS p
ON p.name = a.name
ORDER BY proj_ls DESC, a.name;*/

Select a.name, (1+.5*a.rating)*12 AS proj_mo_ls, a.rating AS half_proj_mo_earn, 10000 * a.price AS purch_price, 1000*(1+.5*a.rating)*12 AS proj_mo_cost
FROM app_store_apps AS a
INNER JOIN play_store_apps AS p
ON p.name = a.name;