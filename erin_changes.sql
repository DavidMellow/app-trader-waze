Select 
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
ORDER BY total_proj_rev DESC;