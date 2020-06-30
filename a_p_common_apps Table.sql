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
	.5* CAST(5000 AS money)* ROUND(12*(a.rating/.5)+12,0)- ((CAST (1000 AS money)*(1+.5*a.rating)*12) +
		(SELECT 
	 	CASE  
	 		WHEN CAST (a.price AS money) <= CAST(1.00 AS money) THEN  CAST (10000 AS money)
	 		ELSE 10000 * CAST (a.price AS money) 
	   		END AS a_purch_price)) AS a_profit,
	a.primary_genre,
	a.content_rating
FROM app_store_apps AS a
ORDER BY a_profit DESC
LIMIT 10