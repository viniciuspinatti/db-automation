CREATE SCHEMA automations
    AUTHORIZATION postgres;

create table automations.person(
	cd_id serial not null primary key,
	name text not null
);

ALTER TABLE automations.person
    RENAME CONSTRAINT person_pkey TO pk_person;

create table automations.choice(
	cd_id serial not null primary key,
	id_person int not null,
	dt_created timestamp not null default current_timestamp::timestamp without time zone,
	foreign key (id_person) references automations.person(cd_id)
);

ALTER TABLE automations.choice
    RENAME CONSTRAINT choice_pkey TO pk_choice;

ALTER TABLE automations.choice
    RENAME CONSTRAINT choice_id_person_fkey TO fk_choice2person;