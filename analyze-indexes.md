## To be grounded with EXPLAIN ANALYZE Query Plan, provide queries for the next cases:

Table “users”:

find user by username (exact match).
find user by part of email (partial match).
Table “tickets”:

Find record by event_id and user_id.
Find record by category in (…).
Analyze and document the queries plan.

~~~~sql
DROP INDEX IF EXISTS users_email_search_idx;
DROP INDEX IF EXISTS users_email_idx;

DROP INDEX IF EXISTS users_username_search_idx;
DROP INDEX IF EXISTS users_username_idx;

DROP INDEX tickets_event_id_idx;
DROP INDEX tickets_user_id_idx;

EXPLAIN ANALYZE
	SELECT * FROM users WHERE username = 'BA7304CCBA99B8B5C3C2A6B';

EXPLAIN ANALYZE
	SELECT * FROM users WHERE email like '%A1%';

EXPLAIN ANALYZE
	SELECT * FROM tickets WHERE event_id = 1000;
~~~~

Add indexes again, check indexes size, document it, prepare queries plan from step 8, compare it with previous result and document it.

~~~~sql
CREATE EXTENSION IF NOT EXISTS pg_trgm;
CREATE INDEX IF NOT EXISTS users_email_search_idx ON users USING GIST (email gist_trgm_ops);
CREATE INDEX IF NOT EXISTS users_email_idx ON users USING HASH (email);

CREATE INDEX IF NOT EXISTS users_username_search_idx ON users USING GIST (username gist_trgm_ops);
CREATE INDEX IF NOT EXISTS users_username_idx ON users USING HASH (username);

CREATE INDEX IF NOT EXISTS tickets_event_id_idx ON tickets (event_id);
CREATE INDEX IF NOT EXISTS tickets_user_id_idx ON tickets (user_id);

EXPLAIN ANALYZE
	SELECT * FROM users WHERE username = 'BA7304CCBA99B8B5C3C2A6B';

EXPLAIN ANALYZE
	SELECT * FROM users WHERE email like '%A1%';

EXPLAIN ANALYZE
	SELECT * FROM tickets WHERE event_id = 1000;

SELECT
    pg_size_pretty (pg_indexes_size('users'));

SELECT
  pg_size_pretty (pg_indexes_size('tickets'));
~~~~

## Results
As expected SELECT after adding indexes takes less time but takes extra space and slows INSERT/UPDATE.


