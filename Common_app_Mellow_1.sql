/*SELECT a_store.name AS a_name, p_store.name AS p_name,
	ROUND(AVG(a_store.rating),1)AS a_avg_rate,
	ROUND(AVG(p_store.rating),1)AS p_avg_rate
FROM app_store_apps AS a_store
LEFT JOIN play_store_apps AS p_store
ON a_store.name = p_store.name 
GROUP BY a_store.name, p_store.name;

SELECT a_avg_rate, p_avg_rate, a_lifespan, p_lifespan*/
/*SELECT
	DISTINCT(a.name),
	(1+.5*a.rating)*12 AS proj_mo_ls, --projected lifespan of app (in months); round to nearest .5
	.5*(5000*(1+.5*a.rating)*12) AS half_proj_mo_earn, --app trader gets 1/2 of projected monthly earnings
	10000 * a.price AS purch_price, --purchase price is $10,000 * app price, but app price <= $1, then purchase price is $10,000
	1000*(1+.5*a.rating)*12 AS proj_mo_cost, --projected monthly maintenance cost is $1000 * lifespan in months
	a.rating - (1000 * a.price + 1000 *(1+.5*a.rating)*12) AS total_proj_rev,
	primary_genre AS app_genre,
	p.genres AS play_genre,
	a.content_rating AS app_content_rating,
	p.content_rating AS play_content_rating
FROM app_store_apps AS a
INNER JOIN play_store_apps AS p
ON p.name = a.name
ORDER BY total_proj_rev DESC;*/



ALTER TABLE app_store_apps
ALTER COLUMN review_count
TYPE numeric
USING review_count::numeric;

SELECT CAST (price AS money)
FROM play_store_apps;

SELECT
	a.name AS a_name, p.name AS p_name,
	ROUND(12*(a.rating/.5)+12,0) AS a_proj_mo_ls,
	ROUND(12*(p.rating/.5)+12,0) AS p_proj_mo_ls,--projected lifespan of app (in months); round to nearest .5
	(.5*5000)* ROUND(12*(a.rating/.5)+12,0) AS proj_ls_earn, --app trader's projected lifespan earnings
	(SELECT 
	 	CASE  
	 		WHEN a.price <= 1.00 THEN  10000
	 		ELSE 10000 * a.price 
	   		END AS a_purch_price),--purchase price is $10,000 * app price, but app price <= $1, then purchase price is $10,000
	1000*(1+.5*a.rating)*12 AS proj_ls_cost, --projected monthly maintenance cost is $1000 * lifespan in months
	1000* (ROUND(12*(a.rating/.5)+12,0)) AS a_ls_proj_rev,--projected life span rev.from app store
	primary_genre AS app_genre,
	p.genres AS play_genre,
	a.content_rating AS app_content_rating,
	p.content_rating AS play_content_rating
FROM app_store_apps AS a
INNER JOIN play_store_apps AS p
ON p.name = a.name
ORDER BY a_ls_proj_rev DESC;


	
	
