drop database if exists health_insurance;
create database health_insurance;

use health_insurance;

drop table if exists plan_type;
create table plan_type
(
	id int auto_increment,
    type varchar(255) not null,
    price numeric(6,2) not null,
    primary key(id)
);

drop table if exists hospitals;
create table hospitals
(
	id int auto_increment ,
    hospital_name varchar(255),
    primary key(id)
);

drop table if exists purchased_plans;
create table purchased_plans
(
	id int auto_increment,
	plan_id int,
    primary key(id),
    -- owner
    foreign key(plan_id) references plan_type(id) 
    on delete cascade
    on update cascade
);


drop table if exists customers;
create table customers
(
	id int auto_increment,
    first_name varchar(50) not null,
    last_name varchar(50) not null,
    phone_number char(11) not null,
    address varchar(255) not null,
    benefits int,
    primary key(id),
    foreign key(benefits) references purchased_plans(id)
);

drop table if exists dependant;
create table dependant
(
	id int auto_increment,
    first_name varchar(20) not null,
    last_name varchar(20) not null,
    customer_id int,
    benefits int,
    
    foreign key(customer_id) references customers(id),    
    primary key(id),
    foreign key(benefits) references purchased_plans(id)
);


alter table purchased_plans add 
(
	owner int,
    foreign key(owner) references customers(id)
);



-- create assertion check_purchased_plans 
-- check exists
-- ( select max(price) from plan_type );