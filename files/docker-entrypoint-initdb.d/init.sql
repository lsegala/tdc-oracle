create table users (
    id bigint not null,
    name character varying(255) not null
);

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

insert into users (id, name) values (1, 'Leonardo');
insert into users (id, name) values (2, 'Rafael');
insert into users (id, name) values (3, 'Otávio');

SELECT pg_catalog.setval('users_id_seq', 3, true);