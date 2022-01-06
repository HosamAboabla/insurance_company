use health_insurance;

insert into plan_type(id , type,price) values(null , 'normal',1234.56);
insert into plan_type(id , type,price) values(null , 'premium',2134.56);
insert into plan_type(id , type,price) values(null , 'golden',4132.56);

insert into customer (name,phone_number,address) values('hossam','01215415615','cairo');
insert into customer (name,phone_number,address) values('galal','01215415615','tanta');
insert into customer (name,phone_number,address) values('reda','01215415615','tanta');

insert into purchased_plans(customer_id,ptype_id) values(1,1);
insert into purchased_plans(customer_id,ptype_id) values(2,2);
insert into purchased_plans(customer_id,ptype_id) values(3,2);
insert into purchased_plans(customer_id,ptype_id) values(1,2);
insert into purchased_plans(customer_id,ptype_id) values(1,2);
insert into purchased_plans(customer_id,ptype_id) values(2,2);
insert into purchased_plans(customer_id,ptype_id) values(2,3);
insert into purchased_plans(customer_id,ptype_id) values(3,2);
insert into purchased_plans(customer_id,ptype_id) values(3,3);


update customer set benplan_id =1 where id=1 ;
update customer set benplan_id =2 where id=2 ;
update customer set benplan_id =3 where id=3 ;


insert into dependant (name,customer_id,benplan_id,relationship) values('ahmed',1,4,'father');
insert into dependant (name,customer_id,benplan_id,relationship) values('shaza',1,5,'daughter');
insert into dependant (name,customer_id,benplan_id,relationship) values('abdallah',2,6,'brother');
insert into dependant (name,customer_id,benplan_id,relationship) values('nasser',2,7,'father');
insert into dependant (name,customer_id,benplan_id,relationship) values('mohamed',3,8,'father');
insert into dependant (name,customer_id,benplan_id,relationship) values('ahmed',3,9,'son');

insert into hospital(name,address) values('Elhorriya','Cairo');
insert into hospital(name,address) values('Elrahman','Alex');
insert into hospital(name,address) values('Elgamaa','Tanta');

insert into has values (1,1);
insert into has values (1,3);
insert into has values (2,1);
insert into has values (2,2);
insert into has values (2,3);
insert into has values (3,2);
insert into has values (3,3);


insert into insurance_claim (expense_amount,expense_details,insurance_date,customer_id,plan_id) values(5000,'heart attack','2021-10-11',1,1);
insert into insurance_claim (expense_amount,expense_details,insurance_date,customer_id,plan_id) values(1000,'medicine','2022-01-02',1,4);
insert into insurance_claim (expense_amount,expense_details,insurance_date,customer_id,plan_id) values(700,'MRI scan','2020-12-08',2,2);
insert into insurance_claim (expense_amount,expense_details,insurance_date,customer_id,plan_id) values(300,'dental examination','2021-11-11',2,7);
insert into insurance_claim (expense_amount,expense_details,insurance_date,customer_id,plan_id) values(2000,'surgery','2020-09-10',3,9);
insert into insurance_claim (expense_amount,expense_details,insurance_date,customer_id,plan_id) values(300,'broken legs','2021-02-03',3,3);
insert into insurance_claim (expense_amount,expense_details,insurance_date,customer_id,plan_id) values(600,'surgery','2022-01-04',1,1);

insert into provides values (1,1,'accident',5);
insert into provides values (3,3,'accident',3);
insert into provides values (2,7,'accident',2);
insert into provides values (1,5,'accident',1);
insert into provides values (1,6,'accident',4);
insert into provides values (3,2,'accident',3);
insert into provides values (2,4,'accident',8);




select * from list_of_customers;

select * from claims;

call claim_detail(2);

select * from list_of_plan_types;

call get_customer_benefits(1);

call dependants_of_customer(2);

call add_customer_benefits(2,7);

call add_dependant_benefits(3,5);

call customer_purchased_plans(1);



select * from customer;
select * from dependant;
select * from has;
select * from hospital;
select * from insurance_claim;
select * from plan_type;
select * from provides;
select * from purchased_plans;