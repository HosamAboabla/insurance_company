-- insert into provides values (1,1,'accident',5);
select * from purch_plans_nums;
select * from customer;
select * from dependant;
select * from insurance_claim;


insert into customer (name,phone_number,address) values('hossam','01215415615','cairo');
insert into customer (name,phone_number,address) values('ahmed','01215415615','tanta');
insert into plan_type(type,price) values('normal',1234.56);
insert into plan_type(type,price) values('premium',2134.56);
insert into plan_type(p_type,price) values('golden',4132.56);
insert into purchased_plans(customer_id,ptype_id) values(1,1);
insert into purchased_plans(customer_id,ptype_id) values(2,2);
update customer set benplan_id =1 where id=1 ;
update customer set benplan_id =2 where id=2 ;
-- insert into customer (c_name,phone_number,address,benplan_id) values('hossam','01215415615','cairo',1);
-- insert into customer (c_name,phone_number,address,benplan_id) values('ahmed','01215415615','tanta',2);
insert into dependant (name,customer_id,benplan_id,relationship) values('ahmed',1,1,'father');
insert into hospital(name,address) values('elhorriya','cairo');
insert into insurance_claim (expense_amount,expense_details,ins_date,customer_id,p_id) values(5000,'heartattack',12/10/2020,1,1);
insert into has values (1,1);
insert into provides values (1,1,'accident',5);