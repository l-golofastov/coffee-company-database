-- Функция для получения информации об управляющем по id плантации
CREATE OR REPLACE FUNCTION get_manager_info(plant_id INTEGER)
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

-- SELECT * FROM get_manager_info(1);


-- Функция для проверки количества партий, принадлежащих конкретной плантации
CREATE OR REPLACE FUNCTION get_plantation_batch_count(plant_id INT)
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

-- SELECT get_plantation_batch_count(1) AS batch_count;

-- Функция для проверки статуса заказа по id
CREATE OR REPLACE FUNCTION get_order_status(order_id INT)
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

-- SELECT get_order_status(1) AS status;
