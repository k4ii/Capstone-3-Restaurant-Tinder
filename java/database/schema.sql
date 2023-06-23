BEGIN TRANSACTION;

DROP TABLE IF EXISTS users;
DROP SEQUENCE IF EXISTS seq_user_id;

CREATE SEQUENCE seq_user_id
  INCREMENT BY 1
  NO MAXVALUE
  NO MINVALUE
  CACHE 1;

CREATE TABLE users (
	user_id int DEFAULT nextval('seq_user_id'::regclass) NOT NULL,
	username varchar(50) NOT NULL,
	password_hash varchar(200) NOT NULL,
	role varchar(50) NOT NULL,
	CONSTRAINT PK_user PRIMARY KEY (user_id)
);

CREATE TABLE "restaurants" (
	"restaurant_id" serial NOT NULL UNIQUE,
	"name" character varying NOT NULL,
	"description" character varying NOT NULL,
	"hours_of_operation" character varying NOT NULL,
	"type" character varying NOT NULL,
	"open" BOOLEAN NOT NULL,
	"phone_number" bigint NOT NULL,
	"rating" int NOT NULL,
	"city" character varying NOT NULL,
	"zip_code" character varying NOT NULL,
	CONSTRAINT "restaurants_pk" PRIMARY KEY ("restaurant_id")
) WITH (
  OIDS=FALSE
);
CREATE TABLE "groups" (
	"group_id" serial NOT NULL,
	"user_id" int NOT NULL,
	"event_name" character varying NOT NULL,
	"end_date" TIMESTAMP NOT NULL,
	"has_ended" BOOLEAN NOT NULL,
	"location" character varying NOT NULL,
	"invite_link" character varying,
	CONSTRAINT "groups_pk" PRIMARY KEY ("group_id")
) WITH (
  OIDS=FALSE
);
CREATE TABLE "restaurant_group" (
	"restaurant_id" int NOT NULL,
	"group_id" int NOT NULL,
	CONSTRAINT "restaurant_group_pk" PRIMARY KEY ("restaurant_id","group_id")
) WITH (
  OIDS=FALSE
);
CREATE TABLE "group_members" (
	"member_id" bigint NOT NULL,
	"member_name" character varying NOT NULL,
	"member_url" character varying NOT NULL,
	"group_id" int NOT NULL,
	"user_vote" int NOT NULL,
	CONSTRAINT "group_members_pk" PRIMARY KEY ("member_id")
) WITH (
  OIDS=FALSE
);
CREATE TABLE "group_votes" (
	"group_id" bigint NOT NULL,
	"member_id" bigint NOT NULL,
	"restaurant_id" bigint NOT NULL,
	"total_votes" int NOT NULL
) WITH (
  OIDS=FALSE
);

ALTER TABLE "groups" ADD CONSTRAINT "groups_fk0" FOREIGN KEY ("user_id") REFERENCES "users"("user_id");
ALTER TABLE "restaurant_group" ADD CONSTRAINT "restaurant_group_fk0" FOREIGN KEY ("restaurant_id") REFERENCES "restaurants"("restaurant_id");
ALTER TABLE "restaurant_group" ADD CONSTRAINT "restaurant_group_fk1" FOREIGN KEY ("group_id") REFERENCES "groups"("group_id");
ALTER TABLE "group_members" ADD CONSTRAINT "group_members_fk0" FOREIGN KEY ("group_id") REFERENCES "groups"("group_id");
ALTER TABLE "group_votes" ADD CONSTRAINT "group_votes_fk0" FOREIGN KEY ("group_id") REFERENCES "groups"("group_id");
ALTER TABLE "group_votes" ADD CONSTRAINT "group_votes_fk1" FOREIGN KEY ("member_id") REFERENCES "group_members"("member_id");
ALTER TABLE "group_votes" ADD CONSTRAINT "group_votes_fk2" FOREIGN KEY ("restaurant_id") REFERENCES "restaurants"("restaurant_id");

INSERT INTO users (username,password_hash,role) VALUES ('user','$2a$08$UkVvwpULis18S19S5pZFn.YHPZt3oaqHZnDwqbCW9pft6uFtkXKDC','ROLE_USER');
INSERT INTO users (username,password_hash,role) VALUES ('admin','$2a$08$UkVvwpULis18S19S5pZFn.YHPZt3oaqHZnDwqbCW9pft6uFtkXKDC','ROLE_ADMIN');

COMMIT TRANSACTION;