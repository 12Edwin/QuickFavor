drop database if exists QuickFavor;
create database QuickFavor;
use QuickFavor;

create table People(
    uid varchar(100) primary key,
    name varchar(220) not null ,
    surname varchar(220) not null ,
    lastname varchar(220) null ,
    email varchar(250) not null unique,
    curp varchar(18) not null  unique ,
    sex enum('Masculino', 'Femenino') not null ,
    role enum('Courier', 'Customer') not null,
    phone varchar(10) not null unique,
    created_at timestamp not null default current_timestamp
);

create table Couriers(
    no_courier varchar(100) primary key,
    fcm_token varchar(255) null,
    rejected_orders int null default 0,
    vehicle_type enum('Carro', 'Moto', 'Bicicleta',  'Scouter', 'Caminando', 'Otro') not null ,
    status enum('Available', 'Busy', 'Out of service') not null,
    license_plate varchar(8),
    id_person varchar(100) not null,
    foreign key (id_person) references People(uid)
);

create table Customers(
    no_customer varchar(100) primary key,
    fcm_token varchar(255) null,
    id_person varchar(100) not null,
    foreign key (id_person) references People(uid)
);

create table Orders(
    no_order varchar(100) primary key,
    description text null,
    created_at timestamp not null default current_timestamp,
    status enum('Pending', 'In shopping', 'In delivery', 'Finished', 'Canceled') not null,
    cost double null,
    id_customer varchar(100) not null,
    id_courier varchar(100),
    foreign key (id_customer) references Customers(no_customer),
    foreign key (id_courier) references Couriers(no_courier)
);

create table Products(
    id int primary key auto_increment,
    name varchar(100) not null,
    description text,
    amount int not null,
    created_at timestamp not null default current_timestamp,
    id_order varchar(100) not null,
    id_customer varchar(100) null,
    foreign key (id_order) references Orders(no_order),
    foreign key (id_customer) references Customers(no_customer)
);

create table Places(
    id int primary key auto_increment,
    name varchar(100) not null,
    location POINT NOT NULL,
    type enum('Home', 'Collection', 'Courier') not null,
    created_at timestamp not null default current_timestamp,
    id_order varchar(100) null,
    id_customer varchar(100) null,
    id_courier varchar(100) null,
    SPATIAL INDEX(location),
    foreign key (id_order) references Orders(no_order),
    foreign key (id_customer) references Customers(no_customer),
    foreign key (id_courier) references Couriers(no_courier)
);

CREATE TABLE Notifications (
  id int auto_increment PRIMARY KEY,
  courier_id VARCHAR(100) NULL,
  customer_id VARCHAR(100) NULL,
  order_id VARCHAR(100) NULL,
  type enum('Order', 'Status', 'System') NOT NULL,
  status enum('Pending', 'Read', 'Deleted') NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (courier_id) REFERENCES Couriers(no_courier),
  FOREIGN KEY (customer_id) REFERENCES Customers(no_customer),
  FOREIGN KEY (order_id) REFERENCES Orders(no_order),
  INDEX idx_driver_order (courier_id, customer_id, order_id)
);

Drop trigger if exists generate_no_courier;
DELIMITER //
CREATE TRIGGER generate_no_courier
BEFORE INSERT ON Couriers
FOR EACH ROW
BEGIN
    DECLARE max_id INT;
    DECLARE new_no_courier VARCHAR(20);
    SELECT IFNULL(MAX(CAST(SUBSTRING(no_courier, 6) AS UNSIGNED)), 0) INTO max_id FROM Couriers;
    SET new_no_courier = CONCAT('COUR_', max_id + 1);
    SET NEW.no_courier = new_no_courier;
END;
//
DELIMITER ;

DROP TRIGGER IF EXISTS generate_no_customer;
DELIMITER //
CREATE TRIGGER generate_no_customer
BEFORE INSERT ON Customers
FOR EACH ROW
BEGIN
    DECLARE max_id INT;
    DECLARE new_no_customer VARCHAR(20);
    SELECT IFNULL(MAX(CAST(SUBSTRING(no_customer, 6) AS UNSIGNED)), 0) INTO max_id FROM Customers;
    SET new_no_customer = CONCAT('CUST_', max_id + 1);
    SET NEW.no_customer = new_no_customer;
END;
//
DELIMITER ;

DROP TRIGGER IF EXISTS generate_no_order;
DELIMITER //
CREATE TRIGGER generate_no_order
BEFORE INSERT ON Orders
FOR EACH ROW
BEGIN
    DECLARE max_id INT;
    DECLARE new_no_order VARCHAR(20);
    SELECT IFNULL(MAX(CAST(SUBSTRING(no_order, 5) AS UNSIGNED)), 0) INTO max_id FROM Orders;
    SET new_no_order = CONCAT('ORD_', max_id + 1);
    SET NEW.no_order = new_no_order;
END;
//
DELIMITER ;

CREATE OR REPLACE VIEW order_details AS
SELECT
    o.no_order,
    o.description,
    o.created_at AS order_created_at,
    o.status,
    o.cost,
    c.no_customer,
    p_cust.name AS customer_name,
    p_cust.surname AS customer_surname,
    p_cust.lastname AS customer_lastname,
    p_cust.email AS customer_email,
    p_cust.phone AS customer_phone,
    cr.no_courier,
    cr.license_plate,
    cr.vehicle_type,
    cr.status AS courier_status,
    p_cour.name AS courier_name,
    p_cour.surname AS courier_surname,
    p_cour.lastname AS courier_lastname,
    p_cour.email AS courier_email,
    p_cour.phone AS courier_phone,
    pl.id AS place_id,
    pl.name AS place_name,
    pl.location AS place_location,
    pl.created_at AS place_created_at
FROM
    Orders o
LEFT JOIN Customers c ON o.id_customer = c.no_customer
LEFT JOIN People p_cust ON c.id_person = p_cust.uid
LEFT JOIN Couriers cr ON o.id_courier = cr.no_courier
LEFT JOIN People p_cour ON cr.id_person = p_cour.uid
LEFT JOIN Places pl ON o.no_order = pl.id_order AND pl.type = 'Home';

SELECT *,
    ST_Distance_Sphere(location, ST_PointFromText(?)) / 1000 as distance_km,
    ST_X(location) AS lat, ST_Y(location) AS lng, c.no_courier, c.fcm_token
    FROM Places p LEFT JOIN Couriers c ON p.id_courier = c.no_courier
    WHERE ST_Distance_Sphere(location, ST_PointFromText(?)) <= ? * 1000
    AND c.status = 'Available'
    ORDER BY distance_km ASC LIMIT 20;