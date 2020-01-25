SELECT a_store.name AS a_name, p_store.name AS p_name,
	ROUND(AVG(a_store.rating),1)AS a_avg_rate,
	ROUND(AVG(p_store.rating),1)AS p_avg_rate
FROM app_store_apps AS a_store
LEFT JOIN play_store_apps AS p_store
ON a_store.name = p_store.name 
GROUP BY a_store.name, p_store.name;

SELECT a_avg_rate, p_avg_rate, a_lifespan, p_lifespan
