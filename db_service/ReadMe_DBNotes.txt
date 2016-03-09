The lib folder must be where the DB functionallity is called. In this case, the the whole process starts at API_Gateway, once the services are redirected to other services and loaded at the same time the API_Gateway is loaded. So, it is necessary for that library to live at root level for this case. 

DB

CREATE TABLE customer
(
customer_id int NOT NULL AUTO_INCREMENT,
name varchar(255),
surname varchar(255),
address varchar(255),
email varchar(255) NOT NULL,
mobile_phone  varchar(255),
other_phone varchar(255),
PRIMARY KEY (customer_id)
);

insert into customer(name, surname, address, email, mobile_phone, other_phone)
values ('Efrin','González','Bregenerodgade 20, 2200 KBN', 'efring@email.com', '29889016', '12345678');

insert into customer(name, surname, address, email, mobile_phone, other_phone)
values ('Charlie','Ghunter','Norregade 10, 1200 KBN', 'charlie@email.com', '11111111', '87654321');

insert into customer(name, surname, address, email, mobile_phone, other_phone)
values ('Carol','Nielsen','Sealand 456, 4200 JULAND', 'carol@email.com', '22222222', '09871234');

insert into customer(name, surname, address, email, mobile_phone, other_phone)
values ('Catherine','Carlsberg','Beachland, 100 ODENSE', 'cath@email.com', '22345222', '09873434');

insert into customer(name, surname, address, email, mobile_phone, other_phone)
values ('Amelie','Sang','Tykobgade, 100 KBN', 'amelie@email.com', '25646222', '09873754');


CREATE TABLE users
(
user_id int NOT NULL AUTO_INCREMENT,
email varchar(255) NOT NULL,
name varchar(255),
password varchar(255),
PRIMARY KEY (user_id)
)

-------------------------------------------
CREATE TABLE adapter_registry
(
service_id int NOT NULL AUTO_INCREMENT,
context varchar(255) NOT NULL,
protocol varchar(255) NOT NULL,
input_port varchar(255),
filepath varchar(255),
location varchar(255),
PRIMARY KEY (service_id)
);

INSERT INTO adapter_registry(context, protocol, input_port, filepath, location)
VALUES ('ProfileA_Adapter','sodep', 'ProfileA','/profileA_service/ProfileA_Adapter.ol','socket://localhost:2001/');

INSERT INTO adapter_registry(context, protocol, input_port, filepath, location)
VALUES ('ProfileB_Adapter','sodep', 'ProfileB','/profileB_service/ProfileB_Adapter.ol','socket://localhost:2002/');

INSERT INTO adapter_registry(context, protocol, input_port, filepath, location)
VALUES ('ProfileC_Adapter','sodep', 'ProfileC','/profileC_service/ProfileC_Adapter.ol','socket://localhost:2003/');



-----------------------------------------------
CREATE TABLE service_registry
(
service_id int NOT NULL AUTO_INCREMENT,
context varchar(255) NOT NULL,
input_port varchar(255),
location varchar(255),
filepath varchar(255),
PRIMARY KEY (service_id)
);


INSERT INTO service_registry(context, input_port, filepath, location)
VALUES ('ProfileA', 'CustomerDB_Service','/db_service/CustomerDB_crud.ol','socket://localhost:8001/');

UPDATE service_registry 
SET input_port='CustomerDB_Service', filepath='/db_service/CustomerDB_crud.ol'	
WHERE service_id='2';
