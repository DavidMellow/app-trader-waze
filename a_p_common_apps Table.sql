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
/*WITH cte_prr AS (
	SELECT ROUND (rating/5,1) *5 
	FROM play_store_apps)
SELECT * 
FROM cte_prr

WITH cte_als AS(
	SELECT ROUND(12*(rating/.5)+12,0)
	FROM app_store_apps)
SELECT *
FROM cte_als;

SELECT CAST (review_count AS numeric)
FROM app_store_apps

SELECT CAST (price AS money)
FROM play_store_apps;*/

/*SELECT
	 CAST review_count AS numeric
	 FROM app_store_apps;
	 CAST (price AS money)
	 FROM play_store_aps;*/

CREATE TABLE a_p_common_apps ( --new table name
	app_name text, --new column names, in order
	a_proj_mo_ls numeric,
	a_proj_ls_earn money,
	a_purch_price money,
	a_proj_ls_main_cost money,
	a_genre text,
	a_content_rating text,
	p_proj_mo_ls numeric,
	p_proj_ls_earn money,
	p_purch_price money,
	p_proj_ls_maint_cost money,
	p_genre text,
	p_content_rating text);
			
INSERT INTO a_p_common_apps(
	app_name, --new column names, in order
	a_proj_mo_ls,
	a_proj_ls_earn,
	a_purch_price,
	a_proj_ls_main_cost,
	a_genre,
	a_content_rating,
	p_proj_mo_ls,
	p_proj_ls_earn,
	p_purch_price,
	p_proj_ls_maint_cost,
	p_genre,
	p_content_rating)
SELECT
	a.name, --corresponding columns to be put into new table in order
	ROUND(12*((ROUND (a.rating/5,1)*5)/.5)+12,0) AS a_proj_mo_ls, --calculates app store lifespan 
	.5* CAST(5000 AS money)* ROUND(12*(a.rating/.5)+12,0) AS a_proj_ls_earn, --calculates app store ls earnings
	(SELECT 
	 	CASE  
	 		WHEN CAST (a.price AS money) <= CAST(1.00 AS money) THEN  CAST (10000 AS money)
	 		ELSE 10000 * CAST (a.price AS money) 
	   		END AS a_purch_price) AS a_purc_price, --calculates app store purchase price
	CAST (1000 AS money)*(1+.5*a.rating)*12 AS a_proj_ls_main_cost, --calculates app store ld maitenance costs
	a.primary_genre,
	a.content_rating,
	ROUND(12*((ROUND (p.rating/5,1)*5)/.5)+12,0) AS p_proj_mo_ls,--calculates play store lifespan 
	(.5* CAST (5000 AS money)) * ROUND(12*(ROUND(12*(ROUND (p.rating/5,1) *5)+12,0)/.5)+12,0) AS p_proj_ls_earn,--calculates app store ls earnings
	(SELECT 		
	    CASE  
	 		WHEN CAST (p.price AS money) <= CAST (1.00 AS money) THEN  CAST (10000 AS money)
	 		ELSE 10000 * CAST (p.price AS money)
	   		END AS p_purch_price) AS p_purch_price,--calculates app store purchase price
	CAST (1000 AS money)*(1+.5*p.rating)*12 AS p_proj_ls_maint_cost,--calculates app store ld maitenance costs
	p.genres,
	p.content_rating 
FROM app_store_apps AS a
INNER JOIN play_store_apps AS p
ON a.name= p.name
ORDER BY a.name;

SELECT *
FROM a_p_common_apps;

/*SELECT name, (a_proj_ls_earn - (a_purch_price + a_projls_main_cost)) AS a_profit
FROM a_p_common_apps;*/

/*SELECT
	DISTINCT (a.name) AS app_name,
--app store columns	
	ROUND(12*(a.rating/.5)+12,0) AS a_proj_mo_ls, --projected monthly lifespan 
	.5* CAST(5000 AS money)* ROUND(12*(a.rating/.5)+12,0) AS a_proj_ls_earn, --app trader's proj lifespan earnings
	(SELECT 
	 	CASE  
	 		WHEN CAST (a.price AS money) <= CAST(1.00 AS money) THEN  CAST (10000 AS money)
	 		ELSE 10000 * CAST (a.price AS money) 
	   		END AS a_purch_price),--purchase price is $10,000 * app price, but app price <= $1, then purchase price is $10,000
	CAST (1000 AS money)*(1+.5*a.rating)*12 AS a_proj_ls_maint_cost,  --proj monthly maintenance cost is $1000 * lifespan in months
	a.primary_genre AS app_genre,
	a.content_rating AS app_content_rating,
--play store columns
	ROUND(12*((ROUND (p.rating/5,1)*5)/.5)+12,0) AS p_proj_mo_ls, --((ROUND (p.rating/5,1)*5) calculates p.rating to nearest .0 or.5) projected monthly lifespan 
	(.5* CAST (5000 AS money)) * ROUND(12*(ROUND(12*(ROUND (p.rating/5,1) *5)+12,0)/.5)+12,0) AS p_proj_ls_earn, --play trader's proj lifespan earnings
	(SELECT 		
	    CASE  
	 		WHEN CAST (p.price AS money) <= CAST (1.00 AS money) THEN  CAST (10000 AS money)
	 		ELSE 10000 * CAST (p.price AS money)
	   		END AS p_purch_price),--purchase price is $10,000 * app price, but app price <= $1, then purchase price is $10,000
	CAST (1000 AS money)*(1+.5*p.rating)*12 AS p_proj_ls_maint_cost, --proj monthly maintenance cost is $1000 * lifespan in months
	p.genres AS play_genre,
	p.content_rating AS play_content_rating
FROM app_store_apps AS a
INNER JOIN play_store_apps AS p
ON a.name = p.name 
ORDER BY a.name;*/
 
