use health_insurance;


insert into customers
(id , first_name , last_name , phone_number , address , benefits)
values (null , "hosam" , "aboabla"  , "01283230373" , "tanta" , null);


select *
from dependant;



select *
from customer;


select *
from hospital;


select *
from plan_type;

select *
from has
where Hosp_id = 1;

INSERT INTO purchased_plans 
(id , customer_id , ptype_id)
VALUES(null , 1 , 2);

select * from purchased_plans;


SELECT LAST_INSERT_ID();

SET foreign_key_checks = 0;
UPDATE customer
SET benplan_id=null
WHERE id=1;
SET foreign_key_checks = 1;