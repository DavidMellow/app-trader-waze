CREATE TABLE a_only_apps ( --new table name
	a_name text, --new column names, in order
	a_proj_mo_ls numeric,
	a_proj_ls_earn money,
	a_purch_price money,
	a_proj_ls_main_cost money,
	a_genre text,
	a_content_rating text);
			
INSERT INTO a_only_apps(
	a_name, --new column names, in order
	a_proj_mo_ls,
	a_proj_ls_earn,
	a_purch_price,
	a_proj_ls_main_cost,
	a_genre,
	a_content_rating)
SELECT
	(SELECT DISTINCT a.name 
		WHERE a.name NOT NULL 
		AND p.name NOT NULL
		AND a.name '%' NOT LIKE p.name '%' ), --corresponding columns to be put into new table in order
	ROUND(12*((ROUND (a.rating/5,1)*5)/.5)+12,0) AS a_proj_mo_ls, --calculates app store lifespan 
	.5* CAST(5000 AS money)* ROUND(12*(a.rating/.5)+12,0) AS a_proj_ls_earn, --calculates app store ls earnings
	(SELECT 
	 	CASE  
	 		WHEN CAST (a.price AS money) <= CAST(1.00 AS money) THEN  CAST (10000 AS money)
	 		ELSE 10000 * CAST (a.price AS money) 
	   		END AS a_purch_price) AS a_purc_price, --calculates app store purchase price
	CAST (1000 AS money)*(1+.5*a.rating)*12 AS a_proj_ls_main_cost, --calculates app store ld maitenance costs
	a.primary_genre,
	a.content_rating
FROM app_store_apps AS a
INNER JOIN play_store_apps AS p
ON a.name = p.name
ORDER BY a.name;

SELECT *
FROM a_only_apps;
/*SELECT COUNT (*)
FROM a_only_apps;*/


