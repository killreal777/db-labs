CREATE TABLE IF NOT EXISTS astronauts (
    id SERIAL PRIMARY KEY,
    name VARCHAR(32) NOT NULL,
    surname VARCHAR(32) NOT NULL,
    birthday DATE NOT NULL
);


CREATE TABLE IF NOT EXISTS positions (
    id SERIAL PRIMARY KEY,
    name VARCHAR(64) NOT NULL
);


CREATE TABLE IF NOT EXISTS ais (
    id SERIAL PRIMARY KEY,
    name VARCHAR(32) NOT NULL,
    version VARCHAR(32) NOT NULL
);


CREATE TABLE IF NOT EXISTS spaceships (
    id SERIAL PRIMARY KEY,
    name VARCHAR(32) NOT NULL,
    ai_id INTEGER REFERENCES ais (id) ON DELETE SET NULL ON UPDATE CASCADE,
    has_manual_control BOOLEAN
);


CREATE TABLE IF NOT EXISTS systems (
    id SERIAL PRIMARY KEY,
    name VARCHAR(32) NOT NULL,
    distance_from_sun BIGINT CHECK (distance_from_sun >= 0)
);


CREATE TABLE IF NOT EXISTS planets (
    id SERIAL PRIMARY KEY,
    name VARCHAR(32) NOT NULL,
    size SMALLINT CHECK (size > 0),
    system_id INTEGER REFERENCES systems (id) ON DELETE SET NULL ON UPDATE CASCADE
);


CREATE TABLE IF NOT EXISTS expeditions (
    id SERIAL PRIMARY KEY,
    destination_planet_id INTEGER REFERENCES planets (id) ON DELETE SET NULL ON UPDATE CASCADE,
    spaceship_id INTEGER REFERENCES spaceships (id) ON DELETE SET NULL ON UPDATE CASCADE,
    start_date DATE NOT NULL,
    end_date DATE CHECK (end_date > start_date)
);


CREATE TABLE IF NOT EXISTS crew (
    expedition_id INTEGER REFERENCES expeditions (id) ON DELETE CASCADE ON UPDATE CASCADE,
    astronaut_id INTEGER REFERENCES astronauts (id) ON DELETE CASCADE ON UPDATE CASCADE,
    position_id INTEGER REFERENCES positions (id) ON DELETE SET NULL ON UPDATE CASCADE,
    PRIMARY KEY (expedition_id, astronaut_id, position_id)
);
