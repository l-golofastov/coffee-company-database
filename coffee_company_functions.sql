-- Функция для получения информации об управляющем по id плантации
CREATE OR REPLACE FUNCTION GetManagerInfo(plant_id INTEGER)
RETURNS TABLE(manager_id INTEGER, first_name VARCHAR, last_name VARCHAR, phone VARCHAR) AS
$$
BEGIN
    RETURN QUERY
    SELECT m.Manager_ID, m.First_Name, m.Last_Name, m.Phone
    FROM Manager AS m
    JOIN Plantation AS p ON p.Manager_ID = m.Manager_ID
    WHERE p.Plantation_ID = plant_id;
END;
$$
LANGUAGE plpgsql;

-- Пример вызова функции:
SELECT * FROM GetManagerInfo(1);

DROP FUNCTION GetManagerInfo(plant_id INTEGER);


-- Функция для подсчета количества партий, принадлежащих конкретной плантации
CREATE OR REPLACE FUNCTION GetPlantationBatchCount(plant_id INT)
RETURNS INT AS
$$
DECLARE
    batch_count INT;
BEGIN
    SELECT COUNT(*) INTO batch_count FROM Batch WHERE Plantation_ID = plant_id;
    RETURN batch_count;
END;
$$
LANGUAGE plpgsql;

-- Пример вызова функции:
SELECT GetPlantationBatchCount(1) AS batch_count;

DROP FUNCTION GetPlantationBatchCount(plant_id INT);


-- Функция для проверки статуса заказа по id
CREATE OR REPLACE FUNCTION GetOrderStatus(order_id INT)
RETURNS VARCHAR(20) AS $$
DECLARE
    status_name VARCHAR(20);
BEGIN
    SELECT Name INTO status_name
    FROM Order_Status
    JOIN Coffee_Order ON Order_Status.Order_Status_ID = Coffee_Order.Order_Status_ID
    WHERE Coffee_Order.Coffee_Order_ID = order_id;
    RETURN status_name;
END;
$$ LANGUAGE plpgsql;

-- Пример вызова функции:
SELECT GetOrderStatus(2) AS status;

DROP FUNCTION GetOrderStatus(order_id INT);
