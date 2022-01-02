drop database if exists health_insurance;
create database health_insurance;

use health_insurance;




create table customer
(
	c_id char(5),
    c_name varchar(20),
    primary key(c_id)
);

create table dependant
(
	customer_id char(5),
    dependant_id char(3) unique,
    dependant_name varchar(20),
    relationship varchar(20),
    primary key(customer_id,dependant_id),
    foreign key (customer_id) references customer(c_id)
);

drop table if exists plan_type;
create table plan_type
(
	id int auto_increment,
    type varchar(255) not null,
    price numeric(6,2) not null,
    primary key(id)
);

create table plan
(
	p_id char(5),
    plan_type varchar(15),
    price int ,
    c_id char(5),
    D_id varchar(20),
    primary key(p_id),
    foreign key(c_id) references customer(c_id),
    foreign key(D_id) references dependant(dependant_id)
);




-- "11111" 1 "00000" null
-- "11112" 1 "00002" null
--
--





create table hospital
(
	H_id char(5),
    hos_name varchar(20),
    primary key(H_id)
);

create table insurance_claim
(
	ins_id char(5),
    expense_amount int,
    expense_details varchar(20),
    claim_beneficiary varchar(20),
    ins_date datetime,
    c_id char(5),
    p_id char(5),
    primary key(ins_id),
    foreign key(c_id) references customer(c_id),
    foreign key(p_id) references plan(p_id)
);

create table has
(
	p_id char(5),
    H_id char(5),
    foreign key(p_id) references plan(p_id),
    foreign key(H_id) references hospital(H_id)
);

create table providies
(
	H_id char(5),
    ins_id char(5),
    foreign key(H_id) references hospital(H_id),
    foreign key(ins_id) references insurance_claim(ins_id)
);

-- insert into customer(c_id,c_name) values('12345','nasser');
-- insert into customer(c_id,c_name) values('12346','nasry');
-- insert into dependant(customer_id,dependant_id,dependant_name,relationship) values ('12345','123','galal nasser','son');
-- insert into dependant(customer_id,dependant_id,dependant_name,relationship) values ('12345','124','abdallah nasser','son');
-- insert into plan(p_id,plan_type,c_id,D_id) values ('12888','place','12345',null);
-- insert into plan(p_id,plan_type,c_id,D_id) values ('12999','place','12346',null);

-- select * from plan;