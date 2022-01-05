drop database if exists health_insurance;
create database health_insurance;

use health_insurance;

drop table if exists customer;
create table customer
(
	id int auto_increment,
    name varchar(20) not null,
    phone_number char(11) not null,
    address varchar(255) not null,
    primary key(id)
);


drop table if exists plan_type;
create table plan_type
(	
	id int auto_increment,
    type varchar(255) unique not null,
    price numeric(6,2) not null,
    primary key(id)
);

insert into plan_type(id , type,price) values(null , 'normal',1234.56);
insert into plan_type(id , type,price) values(null , 'premium',2134.56);
insert into plan_type(id , type,price) values(null , 'golden',4132.56);


drop table if exists purchased_plans;
create table purchased_plans
(
	id int auto_increment,
	customer_id int,
    ptype_id int ,
    primary key(id),
    foreign key(customer_id) references customer(id)
	on delete cascade
	on update cascade,
	foreign key(ptype_id) references plan_type(id)
	on delete set null
	on update cascade
);


alter table customer add 
(
	benplan_id int,	
	foreign key(benplan_id) references purchased_plans(id)
	on delete set null
	on update cascade
);


drop table if exists dependant;
create table dependant
(
	id int auto_increment,
    name varchar(20) not null,
    customer_id int,
    benplan_id int,
    relationship varchar(20),
    birthdate date,
    primary key(id,customer_id) ,
    foreign key(customer_id) references customer(id)
    on delete cascade
    on update cascade,
     foreign key(benplan_id) references purchased_plans(id)
        on delete set null
		on update cascade
);


drop table if exists hospital;
create table hospital
(
	id int auto_increment ,
    name varchar(255),
	address varchar(255) not null,
    primary key(id)
);


drop table if exists insurance_claim;
create table insurance_claim
(
	id int auto_increment,
    expense_amount int,
    expense_details Text,-- varchar(20),
    insurance_date date,
    customer_id int,
    plan_id int,
	-- ben_claim int, 
    resolved bool default false,
    primary key(id),
    foreign key(customer_id) references customer(id)
		on delete cascade
		on update cascade,
    foreign key(plan_id) references purchased_plans(id)
        on delete set null
		on update cascade
);


drop table if exists has;
create table has
(
	plan_id int,
    Hosp_id int,
    foreign key (plan_id) references plan_type(id)
        on delete set null
		on update cascade,
	foreign key (Hosp_id) references hospital(id)
        on delete set null
		on update cascade
);


drop table if exists provides;
create table provides
(
	H_id int,
    ins_id int,
    causeofTreat varchar(100),
    treats_period int,
    foreign key(H_id) references hospital(id)
    on delete set null
	on update cascade,
    foreign key(ins_id) references insurance_claim(id)
    on delete set null
	on update cascade
);





 -- my update 'galal'
create view list_of_customers as
	select * from customer;

select * from list_of_customers;

drop view if exists claims;
create view claims as
	select name , Ic.id , count(Ic.id) as nums 
    from customer c, insurance_claim Ic
    where c.id = Ic.customer_id;

select * from claims;

drop procedure if exists claim_detail;

DElIMITER //
create procedure claim_detail(
In calim_id int 
)
begin
	select * from insurance_claim where id=calim_id;
End //
DELIMITER ;

 

call claim_detail(1);



-- my update 'hosam'

create view list_of_plan_types as
select *
from plan_type;

drop procedure if exists get_customer_benefits;
DElIMITER //
create procedure get_customer_benefits(
In c_id int 
)
begin
	select benplan_id
    from customer 
    where id=c_id ;
End //
DELIMITER ;

drop procedure if exists get_customer_name;
DElIMITER //
create procedure get_customer_name(
In c_id int 
)
begin
	select name
    from customer 
    where id=c_id ;
End //
DELIMITER ;


drop procedure if exists dependants_of_customer;
DElIMITER //
create procedure dependants_of_customer(
In id int 
)
begin
	select dependant.id , name 
    from dependant 
    where dependant.customer_id=id and benplan_id is null
    ;
End //
DELIMITER ;



drop procedure if exists add_customer_benefits;
DElIMITER //
create procedure add_customer_benefits(
In c_id int ,
In plan_id int 
)
begin
	SET foreign_key_checks = 0;
	UPDATE customer
	SET benplan_id=plan_id
	WHERE id=c_id;
	SET foreign_key_checks = 1;
End //
DELIMITER ;


drop procedure if exists add_dependant_benefits;
DElIMITER //
create procedure add_dependant_benefits(
In d_id int ,
In plan_id int 
)
begin
	SET foreign_key_checks = 0;
	UPDATE dependant
	SET benplan_id=plan_id
	WHERE id=d_id;
	SET foreign_key_checks = 1;
End //
DELIMITER ;




drop procedure if exists customer_purchased_plans;
DElIMITER //
create procedure customer_purchased_plans(
In c_id int 
)
begin	
	 select PS.id as id , C.name as name , "customer" as type
	 from customer C,purchased_plans PS 
	 where C.benplan_id=PS.id and C.id = c_id
	 union
	 select PS.id as id , D.name as name , "dependant" as type
	 from dependant D,purchased_plans PS 
	 where D.benplan_id=PS.id and D.customer_id = c_id;
End //
DELIMITER ;



drop procedure if exists file_insurance_claim;
DElIMITER //
create procedure file_insurance_claim(
In expense_amount int ,
In expense_details text ,
In insurance_date date ,
In customer_id int,
In plan_id int,
In resolved bool
)
begin	
		SET foreign_key_checks = 0;
		insert into insurance_claim
		values (null , expense_amount , expense_details , insurance_date , customer_id , plan_id , resolved);
		SET foreign_key_checks = 1;
End //
DELIMITER ;


drop procedure if exists get_plan_beneficary;
DElIMITER //
create procedure get_plan_beneficary(
In plan_id int 
)
begin	
	 select id , name , 'customer' as type
	 from customer 
	 where benplan_id=plan_id
	 union
	 select id , name , 'dependant' as type
	 from dependant 
	 where benplan_id = plan_id;
End //
DELIMITER ;



drop procedure if exists mark_as_resolved;
DElIMITER //
create procedure mark_as_resolved(
In claim_id int 
)
begin
	UPDATE insurance_claim
	SET resolved= true
	WHERE id=claim_id;
End //
DELIMITER ;

call dependants_of_customer(1);
call get_customer_benefits(1);

call customer_purchased_plans(1);

call get_customer_name(1);