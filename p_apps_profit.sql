SELECT
	p.name, --corresponding columns to be put into new table in order
	ROUND(12*((ROUND (p.rating/5,1)*5)/.5)+12,0) AS p_proj_mo_ls, --calculates app store lifespan 
	.5* CAST(5000 AS money)* ROUND(12*(p.rating/.5)+12,0) AS p_proj_ls_earn, --calculates app store ls earnings
	(SELECT 
	 	CASE  
	 		WHEN CAST (p.price AS money) <= CAST(1.00 AS money) THEN  CAST (10000 AS money)
	 		ELSE 10000 * CAST (p.price AS money) 
	   		END AS p_purch_price) AS p_purc_price, --calculates app store purchase price
	CAST (1000 AS money)*(1+.5*p.rating)*12 AS p_proj_ls_main_cost, --calculates app store ld maitenance costs
	.5* CAST(5000 AS money)* ROUND(12*(p.rating/.5)+12,0) - ((CAST (1000 AS money)*(1+.5*p.rating)*12) +
		(SELECT 
	 	CASE  
	 		WHEN CAST (p.price AS money) <= CAST(1.00 AS money) THEN  CAST (10000 AS money)
	 		ELSE 10000 * CAST (p.price AS money) 
	   		END AS p_purch_price)) AS p_profit,
	p.genres,
	p.content_rating
FROM play_store_apps AS p
ORDER BY p_profit DESC
LIMIT 10