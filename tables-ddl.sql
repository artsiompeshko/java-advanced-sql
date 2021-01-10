DROP TABLE IF EXISTS tickets;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS events;

CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  username text UNIQUE NOT NULL,
  first_name text,
  last_name text,
  age integer CHECK (age > 0),
  email text UNIQUE NOT NULL,
  create_date timestamp DEFAULT (now()),
  update_date timestamp DEFAULT (now())
);

CREATE TABLE events (
  id SERIAL PRIMARY KEY,
  title text NOT NULL,
  date timestamp NOT NULL,
  create_date timestamp DEFAULT (now()),
  update_date timestamp DEFAULT (now())
);

CREATE TABLE tickets (
  id SERIAL PRIMARY KEY,
  event_id serial NOT NULL,
  user_id serial NOT NULL,
  category text NOT NULL CHECK (category IN ('ULTRA', 'PREMIUM', 'STANDART')),
  place integer NOT NULL CHECK (place > 0),
  cinema_name text NOT NULL,
  cinema_address text NOT NULL,
  cinema_phone text NOT NULL,
  cinema_facilities text NOT NULL,
  purchase_date timestamp DEFAULT (now()),
  create_date timestamp DEFAULT (now()),
  update_date timestamp DEFAULT (now()),
  CONSTRAINT fk_user
      FOREIGN KEY(user_id)
	      REFERENCES users(id),
  CONSTRAINT fk_event
      FOREIGN KEY(event_id)
	      REFERENCES events(id)
);
