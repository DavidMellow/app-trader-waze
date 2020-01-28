SELECT 	
	app_name,
	(SELECT
	 	CASE --selects longest lifespan
			WHEN a_proj_mo_ls = p_proj_mo_ls THEN a_proj_mo_ls
			WHEN a_proj_mo_ls > p_proj_mo_ls THEN a_proj_mo_ls
			WHEN a_proj_mo_ls < p_proj_mo_ls THEN p_proj_mo_ls
			END ) AS proj_lifespan,
	a_proj_ls_earn + p_proj_ls_earn AS total_earn, --adds app and play earnings
	a_purch_price + p_purch_price AS total_purch_price, --adds app and play purchase
	(SELECT 
		(a_proj_ls_earn + p_proj_ls_earn) - (a_purch_price + p_purch_price) +
			(CASE --selects longest lifespan, which equals # mos.paying advertising
			WHEN a_proj_ls_main_cost = p_proj_ls_maint_cost THEN a_proj_ls_main_cost
			WHEN a_proj_ls_main_cost > p_proj_ls_maint_cost THEN a_proj_ls_main_cost
			WHEN a_proj_ls_main_cost < p_proj_ls_maint_cost THEN p_proj_ls_maint_cost
			END )) AS profit
FROM a_p_common_apps
ORDER BY profit DESC
LIMIT 15;