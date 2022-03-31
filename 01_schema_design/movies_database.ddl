-- Создание схемы
CREATE SCHEMA IF NOT EXISTS content;

-- Создание таблицы film_work в схеме content
CREATE TABLE IF NOT EXISTS content.film_work (
    id uuid PRIMARY KEY,
    title TEXT NOT NULL UNIQUE,
    description TEXT,
    creation_date DATE,
    rating FLOAT,
    type TEXT NOT NULL,
    created timestamp with time zone,
    modified timestamp with time zone
);

--создание индекса по creation_date и отдельно по title
CREATE INDEX IF NOT EXISTS film_work_creation_date_idx ON content.film_work(creation_date);
CREATE INDEX IF NOT EXISTS film_work_title_idx ON content.film_work(title);


-- Создание таблицы genre в схеме content
CREATE TABLE IF NOT EXISTS content.genre (
    id uuid PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    description TEXT,
    created timestamp with time zone,
    modified timestamp with time zone
);

--Создание таблицы person в схеме content
CREATE TABLE IF NOT EXISTS content.person (
    id uuid PRIMARY KEY,
    full_name TEXT NOT NULL UNIQUE,
    created timestamp with time zone,
    modified timestamp with time zone
);

--Создание таблицы связи genre - film_work в схеме content
CREATE TABLE IF NOT EXISTS content.genre_film_work (
    id uuid PRIMARY KEY,
    genre_id uuid NOT NULL,
    film_work_id uuid NOT NULL,
    created timestamp with time zone
);

--Создание таблицы связи person - film_work в схеме content
CREATE TABLE IF NOT EXISTS content.person_film_work (
    id uuid PRIMARY KEY,
    person_id uuid NOT NULL,
    film_work_id uuid NOT NULL,
    role TEXT NOT NULL,
    created timestamp with time zone
);

--уникальный индекс для genre-film-work по полям id
ALTER TABLE content.genre_film_work ADD CONSTRAINT unique_film_work_genre UNIQUE (film_work_id, genre_id);

--уникальный индекс для person-film-work по полям id и по роли(1 человек мог быть и режиссером и продюсером)
ALTER TABLE content.person_film_work ADD CONSTRAINT unique_film_work_person_role UNIQUE (film_work_id, person_id, role);
