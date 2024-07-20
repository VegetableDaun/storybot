CREATE TABLE readers
(
    id SERIAL PRIMARY KEY,
    userid bigint UNIQUE NOT NULL
);

CREATE TABLE list_stories
(
    id SERIAL PRIMARY KEY,
    title text NOT NULL
);

CREATE TABLE progress_stories
(
    id SERIAL PRIMARY KEY,
    id_user integer,
    id_story integer,
    progress JSONB NOT NULL,
    points JSONB NOT NULL,

    CONSTRAINT user_constrain
        FOREIGN KEY (id_user) REFERENCES readers(id),

    CONSTRAINT st_constrain
        FOREIGN KEY (id_story) REFERENCES list_stories(id),

    CONSTRAINT story_constrain UNIQUE (id_user, id_story)
);

CREATE TABLE line_story_1
(
    id SERIAL PRIMARY KEY,
    start_state text NOT NULL ,
    last_state text NOT NULL ,
    answer text NOT NULL ,
    award JSONB NOT NULL ,
    restrict JSONB NOT NULL ,
    condition_points JSONB NOT NULL,
    message text NOT NULL
);