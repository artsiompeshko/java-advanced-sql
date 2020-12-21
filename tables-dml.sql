DELETE FROM tickets;
DELETE FROM events;
DELETE FROM users;

CREATE OR REPLACE FUNCTION random_text(length INTEGER)
RETURNS TEXT
LANGUAGE PLPGSQL
AS $$
DECLARE
  -- how many md5's we need to have at least length chars
  loop_count INTEGER := CEIL(length / 32.);
  output TEXT := ''; -- the result text
  i INT4; -- loop counter
BEGIN
  FOR i IN 1..loop_count LOOP
    output := output || md5(random()::TEXT);
  END LOOP;
  -- get the substring for the exact number of characters
  -- and upper them up
  RETURN upper(substring(output, length));
END $$;

CREATE OR REPLACE FUNCTION populate_tables(number_of_records INTEGER)
RETURNS void
LANGUAGE plpgsql
AS $$
DECLARE eventId INTEGER;
DECLARE userId INTEGER;
BEGIN
  FOR i IN 1..number_of_records LOOP
    INSERT INTO events(title, date)
      VALUES(random_text(10), current_timestamp)
      RETURNING id INTO eventId;
    INSERT INTO users(username, first_name, last_name, age, email)
      VALUES(random_text(10), random_text(5), random_text(5), floor(random() * 10) + 1, random_text(20))
      RETURNING id INTO userId;
    INSERT INTO tickets(event_id, user_id, category, place, cinema_name, cinema_address, cinema_phone, cinema_facilities, purchase_date)
      VALUES(eventId, userId, (ARRAY['ULTRA','PREMIUM','STANDART'])[floor(random()*3)+1], floor(random() * 10) + 1, random_text(5), random_text(5), random_text(5), random_text(5), current_timestamp);
  END LOOP;
END $$;

select public.populate_tables(100);
