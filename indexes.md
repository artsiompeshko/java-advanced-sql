## What kind of index PostgreSQL creates when we use default CREATE INDEX command?
By default PostgreSQL creates B-trees index which fit the most common situatations.

B-trees can handle equality and range queries on data that can be sorted into some ordering. In particular, the PostgreSQL query planner will consider using a B-tree index whenever an indexed column is involved in a comparison using one of these operators: < <= = >= >.

## What is the use case of each type of index?

#### B-tree
See above.

#### Hash
Hash indexes can only handle simple equality comparisons. The query planner will consider using a hash index whenever an indexed column is involved in a comparison using the = operator.

#### GIST
Gist or Generalized Search Tree are useful when the data to be indexed is more complex than to do a simple equate or ranged comparison like finding nearest-neighbor and pattern matching. The example of such data includes geometric data, network address comparisons and full-text searches.

#### GIN
Generalized Inverted indexes are useful in indexing data that consist of multiple elements in a single column such as arrays, json documents (jsonb) or text search documents (tsvector).

## Provide examples for indexes creating.
GIST for email and username full text search.
HASH for email and username to search by = only.

B-Tree for event_id and user_id to search by < <= = >= >.
~~~~sql
CREATE EXTENSION IF NOT EXISTS pg_trgm;
CREATE INDEX IF NOT EXISTS users_email_search_idx ON users USING GIST (email gist_trgm_ops);
CREATE INDEX IF NOT EXISTS users_email_idx ON users USING HASH (email);

CREATE INDEX IF NOT EXISTS users_username_search_idx ON users USING GIST (username gist_trgm_ops);
CREATE INDEX IF NOT EXISTS users_username_idx ON users USING HASH (username);

CREATE INDEX IF NOT EXISTS tickets_event_id_idx ON tickets (event_id);
CREATE INDEX IF NOT EXISTS tickets_user_id_idx ON tickets (user_id);
~~~~

## Pros and cons of using indexes.
Well, the obvious answer is that indexes speeds up the select operation (no matter direct SELECT or via JOIN). The downside that indexes slow down an insert and update, since we need to update indexes files as well. They also took additional memory space.

## Based on the investigation result from step 4, decide what kind/s of index/es will be suitable for tables from step 1 and provide it (be aware that table “users” will be used for searching by username or by email; table “tickets” will be used for searching by event_id and user_id).
GIST for email and username full text search.
HASH for email and username to search by = only.

B-Tree for event_id and user_id to search by < <= = >= >.

## Define how to get indexes size in PostgreSQL and check the size of provided indexes, document the result and remove indexe
users tables indexes took 43mb for me. It is much bigger than tickets indexes since we need to store all substrings for full text search options.

~~~~sql
SELECT
    pg_size_pretty (pg_indexes_size('users'));

SELECT
  pg_size_pretty (pg_indexes_size('tickets'));
~~~~
