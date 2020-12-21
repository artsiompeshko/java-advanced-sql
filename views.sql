CREATE OR REPLACE VIEW count_by_month AS
	SELECT date_part('month', e.date), t.category, u.age, count(t.id) from tickets t
	LEFT JOIN users u
		ON t.user_id = u.id
	LEFT JOIN events e
		ON t.event_id = e.id
GROUP BY date_part('month', e.date), t.category, u.age;

SELECT * from count_by_month;

CREATE OR REPLACE VIEW stats AS
SELECT
	t.category,
	AVG(DATE_PART('day', t.purchase_date - e.date) * 24 + DATE_PART('hour', t.purchase_date - e.date)) as avg_diff,
	MODE() WITHIN GROUP (ORDER BY u.age) as most_frequent_user_age,
	((count(*)::float / tt.total)::float * 100) as category_percentage
FROM tickets t
LEFT JOIN events e
	ON t.event_id = e.id
LEFT JOIN users u
	ON t.user_id = u.id
LEFT JOIN (
	SELECT count(*) as total FROM tickets
) AS tt
ON 1 = 1
GROUP BY t.category, tt.total;

SELECT * FROM stats;


