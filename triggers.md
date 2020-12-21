##  Investigate pros and cons triggers and document it.
In general, it is better to keep the logic at application layer. Usually, triggers are only used for inserting updated_at timestamps.

## Add triggers that fill columns “update_date” and “create_date” to current date and time for all tables from step 1.

For create_date I used default value.

~~~~sql
CREATE OR REPLACE FUNCTION trigger_set_timestamp()
RETURNS TRIGGER AS $$
BEGIN
  NEW.update_date = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS
  users_update_date ON users;

CREATE TRIGGER users_update_date
  BEFORE UPDATE ON users
  FOR EACH ROW
  EXECUTE PROCEDURE trigger_set_timestamp();
~~~~
