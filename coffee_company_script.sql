-- CREATE DATABASE coffee_company;
-- GO
-- USE coffee_company;


CREATE TABLE Manager(
                        Manager_ID          INTEGER      NOT NULL,
                        First_Name          VARCHAR(20)  NOT NULL,
                        Last_Name           VARCHAR(20)  NOT NULL,
                        Phone               VARCHAR(15)  NOT NULL,
                        CONSTRAINT Manager_PK PRIMARY KEY (Manager_ID)
)
;

CREATE TABLE Coffee_Sort(
                            Coffee_Sort_ID      INTEGER      NOT NULL,
                            Name                VARCHAR(20)  NOT NULL,
                            Price_Per_Kg        INTEGER      NOT NULL,
                            CONSTRAINT Coffee_Sort_PK PRIMARY KEY (Coffee_Sort_ID)
)
;

CREATE TABLE Plantation(
                           Plantation_ID       INTEGER      NOT NULL,
                           Name                VARCHAR(50)  NOT NULL,
                           Address             VARCHAR(50)  NOT NULL,
                           Manager_ID          INTEGER      NOT NULL,
                           Coffee_Sort_ID      INTEGER      NOT NULL,
                           CONSTRAINT Plantation_PK PRIMARY KEY (Plantation_ID),
                           CONSTRAINT Plantation_FK_Manager FOREIGN KEY (Manager_ID) REFERENCES Manager (Manager_ID) ON DELETE CASCADE,
                           CONSTRAINT Plantation_FK_Coffee_Sort FOREIGN KEY (Coffee_Sort_ID) REFERENCES Coffee_Sort (Coffee_Sort_ID) ON DELETE CASCADE,
                           CONSTRAINT Plantation_UQ_Name UNIQUE (Name)
)
;

CREATE TABLE Batch(
                      Batch_ID            INTEGER         NOT NULL,
                      Plantation_ID       INTEGER         NOT NULL,
                      Amount_Kg           INTEGER         NOT NULL,
                      Total_Price         INTEGER         NOT NULL,
                      CONSTRAINT Batch_PK PRIMARY KEY (Batch_ID),
                      CONSTRAINT Batch_FK_Plantation FOREIGN KEY (Plantation_ID) REFERENCES Plantation (Plantation_ID) ON DELETE CASCADE,
                      CONSTRAINT Batch_CHK_Amount_Kg CHECK (Amount_Kg > 0)
)
;

CREATE TABLE Port(
                     Port_ID             INTEGER      NOT NULL,
                     Country             VARCHAR(20)  NOT NULL,
                     City                VARCHAR(20)  NOT NULL,
                     Name                VARCHAR(20)  NOT NULL,
                     CONSTRAINT Port_PK PRIMARY KEY (Port_ID),
                     CONSTRAINT Port_UQ_Country_City UNIQUE (Country, City)
)
;

CREATE TABLE Customer(
                         Customer_ID         INTEGER      NOT NULL,
                         Name                VARCHAR(20)  NOT NULL,
                         CONSTRAINT Customer_PK PRIMARY KEY (Customer_ID),
                         CONSTRAINT Customer_UQ_Name UNIQUE (Name)
)
;

CREATE TABLE Order_Status(
                             Order_Status_ID     INTEGER      NOT NULL,
                             Name                VARCHAR(20)  NOT NULL,
                             CONSTRAINT Order_Status_PK PRIMARY KEY (Order_Status_ID),
                             CONSTRAINT Order_Status_UQ_Name UNIQUE (Name)
)
;

CREATE TABLE Coffee_Order(
                             Coffee_Order_ID     INTEGER      NOT NULL,
                             Customer_ID         INTEGER      NOT NULL,
                             Batch_ID            INTEGER         NOT NULL,
                             Port_ID             INTEGER      NOT NULL,
                             Order_Status_ID     INTEGER,
                             CONSTRAINT Coffee_Order_PK PRIMARY KEY (Coffee_Order_ID),
                             CONSTRAINT Coffee_Order_FK_Customer FOREIGN KEY (Customer_ID) REFERENCES Customer (Customer_ID) ON DELETE CASCADE,
                             CONSTRAINT Coffee_Order_FK_Batch FOREIGN KEY (Batch_ID) REFERENCES Batch (Batch_ID) ON DELETE CASCADE,
                             CONSTRAINT Coffee_Order_FK_Port FOREIGN KEY (Port_ID) REFERENCES Port (Port_ID) ON DELETE CASCADE,
                             CONSTRAINT Coffee_Order_FK_Order_Status FOREIGN KEY (Order_Status_ID) REFERENCES Order_Status (Order_Status_ID) ON DELETE CASCADE
)
;

CREATE INDEX idx_Manager_First_Name_Last_Name ON Manager (First_Name, Last_Name);

-- Заполнение таблицы Manager
INSERT INTO Manager (Manager_ID, First_Name, Last_Name, Phone)
VALUES
    (1, 'John', 'Doe', '123456789'),
    (2, 'Jane', 'Smith', '987654321'),
    (3, 'Mike', 'Johnson', '555555555'),
    (4, 'Sarah', 'Williams', '111111111'),
    (5, 'David', 'Brown', '222222222'),
    (6, 'Emily', 'Taylor', '333333333'),
    (7, 'Michael', 'Anderson', '444444444');


-- Заполнение таблицы Coffee_Sort
INSERT INTO Coffee_Sort (Coffee_Sort_ID, Name, Price_Per_Kg)
VALUES
    (1, 'Arabica', 10),
    (2, 'Robusta', 8),
    (3, 'Liberica', 12),
    (4, 'Excelsa', 9),
    (5, 'Catimor', 11),
    (6, 'Typica', 13),
    (7, 'Bourbon', 14);


-- Заполнение таблицы Plantation
INSERT INTO Plantation (Plantation_ID, Name, Address, Manager_ID, Coffee_Sort_ID)
VALUES
    (1, 'Finca El Injerto', '123 Main Street', 1, 1),
    (2, 'Hacienda La Esmeralda', '456 Elm Street', 2, 2),
    (3, 'Fazenda Santa Alina', '789 Oak Street', 3, 1),
    (5, 'Fazelina', '786 Oak Street', 5, 1),
    (4, 'Finca El Puente', '321 Pine Street', 4, 3);

-- Заполнение таблицы Batch
INSERT INTO Batch (Batch_ID, Plantation_ID, Amount_Kg, Total_Price)
VALUES
    (1, 1, 100, 1000),
    (2, 2, 200, 1500),
    (3, 3, 150, 1200),
    (4, 4, 120, 1100);

-- Заполнение таблицы Port
INSERT INTO Port (Port_ID, Country, City, Name)
VALUES
    (1, 'Brazil', 'Santos', 'Port Santos'),
    (2, 'Colombia', 'Buenaventura', 'Port Buenaventura'),
    (3, 'Vietnam', 'Ho Chi Minh City', 'Port Ho Chi Minh'),
    (4, 'Indonesia', 'Jakarta', 'Port Jakarta');

-- Заполнение таблицы Customer
INSERT INTO Customer (Customer_ID, Name)
VALUES
    (1, 'Starbucks'),
    (2, 'Dunkin Donuts'),
    (3, 'Costa Coffee'),
    (4, 'Tim Hortons'),
    (5, 'Nespresso');

-- Заполнение таблицы Order_Status
INSERT INTO Order_Status (Order_Status_ID, Name)
VALUES
    (1, 'New'),
    (2, 'Processing'),
    (3, 'Completed'),
    (4, 'Cancelled'),
    (5, 'On Hold');

-- Заполнение таблицы Coffee_Order
INSERT INTO Coffee_Order (Coffee_Order_ID, Customer_ID, Batch_ID, Port_ID, Order_Status_ID)
VALUES
    (1, 1, 3, 4, 2),
    (2, 2, 2, 3, 1),
    (3, 3, 1, 2, 3),
    (4, 4, 4, 1, 4);


-- 1. Вывести список портов, в которые были доставлены партии кофе с ценой выше средней цены всех партий:
SELECT Name FROM Port
    WHERE Port_ID IN (
        SELECT Port_ID
            FROM Coffee_Order
                JOIN Batch ON Coffee_Order.Batch_ID = Batch.Batch_ID
                    WHERE Total_Price > (
                        SELECT AVG(Total_Price)
                            FROM Batch
    )
);


-- 2. Посчитать общее количество килограмм кофе в каждой партии:
SELECT Batch_ID, SUM(Amount_Kg) AS Total_Amount
    FROM Batch
        GROUP BY Batch_ID;

-- 3. Вывести информацию о плантации и ее управляющем для всех партий кофе:
SELECT b.Batch_ID, p.Name AS Plantation_Name, m.First_Name, m.Last_Name
    FROM Batch b
        JOIN Plantation p ON b.Plantation_ID = p.Plantation_ID
        JOIN Manager m ON p.Manager_ID = m.Manager_ID;


-- 4. Вывеси список всех заказчиков и плантаций, отсортированных по алфавиту:
(
    SELECT Name AS Entity_Name, 'Customer' AS Entity_Type
        FROM Customer
)
UNION
(
    SELECT Manager.First_Name AS Entity_Name, 'Manager' AS Entity_Type
        FROM Manager
 );


-- 5. Вывести информацию о заказчике, партии кофе и статусе заказа:
SELECT c.Name AS Customer_Name, b.Batch_ID, o.Name AS Order_Status
    FROM Coffee_Order co
        JOIN Customer c ON co.Customer_ID = c.Customer_ID
        JOIN Batch b ON co.Batch_ID = b.Batch_ID
        JOIN Order_Status o ON co.Order_Status_ID = o.Order_Status_ID;

-- 6. Вывести все партии кофе, у которых количество кофе больше 100 кг и цена за килограмм меньше 12:
SELECT * FROM Batch
    WHERE Amount_Kg > 100
    AND Total_Price / Amount_Kg < 12;

-- 7. Вывести информацию о плантациях, у которых управляющего зовут David:
SELECT p.Name AS Plantation_Name, p.Address
    FROM Plantation p
        LEFT JOIN Manager m ON p.Manager_ID = m.Manager_ID
            WHERE m.First_Name = 'David';


-- 8. Вывести количество партий кофе для каждого порта:
SELECT p.Name AS Port_Name, COUNT(co.Batch_ID) AS Total_Batches
    FROM Port p
        LEFT JOIN Coffee_Order co ON p.Port_ID = co.Port_ID
            GROUP BY p.Name;


-- 9. Вывести информацию о плантации, на которой выращивают сорт Arabica:
SELECT P.Name, P.Address FROM Plantation P
    JOIN Coffee_Sort C ON P.Coffee_Sort_ID = C.Coffee_Sort_ID
        WHERE C.Name = 'Arabica';

-- 10. Вывести информацию о заказчиках, у которых суммарное количество кофе в заказах больше 100 кг:
SELECT c.Name AS Customer_Name, SUM(b.Amount_Kg) AS Total_Coffee
    FROM Customer c
        JOIN Coffee_Order co ON c.Customer_ID = co.Customer_ID
        JOIN Batch b ON co.Batch_ID = b.Batch_ID
            GROUP BY c.Name
                HAVING SUM(b.Amount_Kg) > 100;


-- 11. Вывести суммарную стоимость всех заказов для каждого заказчика, отсортированную по убыванию суммарной стоимости:
SELECT Customer.Name, SUM(Batch.Total_Price) AS Total_Cost
    FROM Customer
        JOIN Coffee_Order ON Customer.Customer_ID = Coffee_Order.Customer_ID
        JOIN Batch ON Coffee_Order.Batch_ID = Batch.Batch_ID
            GROUP BY Customer.Name
                ORDER BY Total_Cost DESC;

-- 12. Вывести все плантации, на которых выращивается кофе с ценой выше средней цены всех сортов,
-- и отсортировать их по убыванию цены кофе:
SELECT Plantation.Name, Coffee_Sort.Name, Coffee_Sort.Price_Per_Kg
    FROM Plantation
        JOIN Coffee_Sort ON Plantation.Coffee_Sort_ID = Coffee_Sort.Coffee_Sort_ID
            WHERE Coffee_Sort.Price_Per_Kg > (SELECT AVG(Price_Per_Kg) FROM Coffee_Sort)
                ORDER BY Coffee_Sort.Price_Per_Kg DESC;

-- 13. Вывести информацию о сортах кофе
SELECT * FROM Coffee_Sort;


-- 1. Представление, показывающее информацию о клиентах и количестве их заказов
CREATE VIEW V_CustomerOrderCount AS
    SELECT c.Customer_ID, c.Name, COUNT(co.Coffee_Order_ID) AS Order_Count
        FROM Customer c
            LEFT JOIN Coffee_Order co ON c.Customer_ID = co.Customer_ID
                GROUP BY c.Customer_ID, c.Name;

SELECT * FROM V_CustomerOrderCount;

-- 2. Представление, показывающее информацию о партиях кофе и связанных с ними портах
CREATE VIEW V_BatchPortInfo AS
    SELECT b.Batch_ID, b.Amount_Kg, p.Name AS Port_Name, p.City, p.Country
        FROM Batch b
            INNER JOIN Coffee_Order co ON b.Batch_ID = co.Batch_ID
            INNER JOIN Port p ON co.Port_ID = p.Port_ID;

SELECT * FROM V_BatchPortInfo;

-- 3. Представление, показывающее информацию о плантациях и сортах кофе, выращиваемых на них
CREATE VIEW V_PlantationCoffeeSort AS
    SELECT p.Name AS Plantation_Name, p.Address, cs.Name AS Coffee_Sort_Name, cs.Price_Per_Kg
        FROM Plantation p
            INNER JOIN Coffee_Sort cs ON p.Coffee_Sort_ID = cs.Coffee_Sort_ID;

SELECT * FROM V_PlantationCoffeeSort;

-- Удаление
DROP VIEW V_CustomerOrderCount;
DROP VIEW V_BatchPortInfo;
DROP VIEW V_PlantationCoffeeSort;
DROP TABLE Coffee_Order;
DROP TABLE Order_Status;
DROP TABLE Customer;
DROP TABLE Port;
DROP TABLE Batch;
DROP TABLE Plantation;
DROP TABLE Coffee_Sort;
DROP TABLE Manager;
