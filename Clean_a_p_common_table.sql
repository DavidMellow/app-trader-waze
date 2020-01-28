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
	DISTINCT a.name, --corresponding columns to be put into new table in order
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



