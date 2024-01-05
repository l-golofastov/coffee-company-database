-- Триггер на обновление цены кофе:
CREATE OR REPLACE FUNCTION UpdateBatchTotalPrice()
RETURNS TRIGGER AS
$$
BEGIN
    UPDATE Batch
    SET Total_Price = NEW.Price_Per_Kg * Amount_Kg
    WHERE NEW.Coffee_Sort_ID = OLD.Coffee_Sort_ID;
    RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER Tr_After_Update_Coffee_Price
AFTER UPDATE OF Price_Per_Kg ON Coffee_Sort
FOR EACH ROW
EXECUTE FUNCTION UpdateBatchTotalPrice();

-- Пример работы:
SELECT * FROM batch
    JOIN plantation ON batch.plantation_id = plantation.plantation_id
    JOIN coffee_sort ON plantation.coffee_sort_id = coffee_sort.coffee_sort_id
        WHERE coffee_sort.coffee_sort_id = 1;

UPDATE Coffee_Sort
SET Price_Per_Kg = 15
WHERE Coffee_Sort_ID = 1;

SELECT * FROM batch
    JOIN plantation ON batch.plantation_id = plantation.plantation_id
    JOIN coffee_sort ON plantation.coffee_sort_id = coffee_sort.coffee_sort_id
        WHERE coffee_sort.coffee_sort_id = 1;


-- Триггер на удаление клиента, удаляющий также соответствующие заказы
CREATE OR REPLACE FUNCTION DeleteRelatedOrders()
RETURNS TRIGGER AS
$$
BEGIN
    DELETE FROM Coffee_Order
    WHERE Customer_ID = OLD.Customer_ID;
    RETURN OLD;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER Tr_After_Delete_Customer
AFTER DELETE ON Customer
FOR EACH ROW
EXECUTE FUNCTION DeleteRelatedOrders();

-- Пример работы:
SELECT count(*) from coffee_order;

DELETE FROM Customer
WHERE Customer_ID = 1;

SELECT count(*) from coffee_order;


-- Триггер присвоения статуса заказа по умолчанию при создании заказа
CREATE OR REPLACE FUNCTION AssignInitialOrderStatus()
RETURNS TRIGGER AS
$$
BEGIN
    NEW.Order_Status_ID := 1;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER Tr_Assign_Initial_Order_Status
BEFORE INSERT ON Coffee_Order
FOR EACH ROW
EXECUTE FUNCTION AssignInitialOrderStatus();

-- Пример работы
SELECT coffee_order.order_status_id from coffee_order;

INSERT INTO Coffee_Order (Coffee_Order_ID, Customer_ID, Batch_ID, Port_ID, Order_Status_ID)
VALUES (5, 2, 3, 4, NULL);

SELECT coffee_order_id, order_status_id from coffee_order;
