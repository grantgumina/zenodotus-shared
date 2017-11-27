-- LINKS SETUP

CREATE TABLE links (
    id integer NOT NULL,
    url text NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT current_timestamp
);

CREATE SEQUENCE links_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE links_id_seq OWNED BY links.id;
ALTER TABLE ONLY links ALTER COLUMN id SET DEFAULT nextval('links_id_seq'::regclass);
ALTER TABLE ONLY links ADD CONSTRAINT link_url_unique UNIQUE (url);
ALTER TABLE ONLY links ADD CONSTRAINT links_pkey PRIMARY KEY (id);

-- MESSAGES SETUP
CREATE TABLE messages (
    id integer NOT NULL,
    body text NOT NULL,
    sender text NOT NULL,
    channel text NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT current_timestamp
);
CREATE SEQUENCE messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE messages_id_seq OWNED BY messages.id;
ALTER TABLE ONLY messages ALTER COLUMN id SET DEFAULT nextval('messages_id_seq'::regclass);
ALTER TABLE ONLY messages ADD CONSTRAINT messages_pkey PRIMARY KEY (id);

-- TAGS SETUP
CREATE TABLE tags (
    id integer NOT NULL,
    name text NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT current_timestamp
);

CREATE SEQUENCE tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE tags_id_seq OWNED BY tags.id;

ALTER TABLE ONLY tags ALTER COLUMN id SET DEFAULT nextval('tags_id_seq'::regclass);
ALTER TABLE ONLY tags ADD CONSTRAINT tag_name_unique UNIQUE (name);
ALTER TABLE ONLY tags ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


-- TAGGED_LINKS SETUP
CREATE TABLE tagged_links (
    id integer NOT NULL,
    tag_id integer,
    link_id integer,
    created_at TIMESTAMP NOT NULL DEFAULT current_timestamp
);

CREATE SEQUENCE "tagged_links_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE "tagged_links_id_seq" OWNED BY tagged_links.id;
ALTER TABLE ONLY tagged_links ALTER COLUMN id SET DEFAULT nextval('"tagged_links_id_seq"'::regclass);
ALTER TABLE ONLY tagged_links ADD CONSTRAINT "tagged_links_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY tagged_links ADD CONSTRAINT "tagged_links_link_id_fkey" FOREIGN KEY (link_id) REFERENCES links(id);
ALTER TABLE ONLY tagged_links ADD CONSTRAINT "tagged_links_tag_id_fkey" FOREIGN KEY (tag_id) REFERENCES tags(id);

-- TAGGED_MESSAGES SETUP
CREATE TABLE tagged_messages (
    id integer NOT NULL,
    message_id integer,
    tag_id integer,
    created_at TIMESTAMP NOT NULL DEFAULT current_timestamp
);

CREATE SEQUENCE "tagged_messages_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE "tagged_messages_id_seq" OWNED BY tagged_messages.id;
ALTER TABLE ONLY tagged_messages ALTER COLUMN id SET DEFAULT nextval('"tagged_messages_id_seq"'::regclass);
ALTER TABLE ONLY tagged_messages ADD CONSTRAINT "tagged_messages_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY tagged_messages ADD CONSTRAINT "tagged_messages_message_id_fkey" FOREIGN KEY (message_id) REFERENCES messages(id);
ALTER TABLE ONLY tagged_messages ADD CONSTRAINT "tagged_messages_tag_id_fkey" FOREIGN KEY (tag_id) REFERENCES tags(id);