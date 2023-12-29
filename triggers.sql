CREATE OR REPLACE FUNCTION update_batch_total_price()
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

-- Триггер на обновление цены кофе:
CREATE TRIGGER after_update_coffee_price
AFTER UPDATE OF Price_Per_Kg ON Coffee_Sort
FOR EACH ROW
EXECUTE FUNCTION update_batch_total_price();

/*
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
*/


CREATE OR REPLACE FUNCTION delete_related_orders()
RETURNS TRIGGER AS
$$
BEGIN
    DELETE FROM Coffee_Order
    WHERE Customer_ID = OLD.Customer_ID;
    RETURN OLD;
END;
$$
LANGUAGE plpgsql;

-- Триггер на удаление клиента
CREATE TRIGGER after_delete_customer
AFTER DELETE ON Customer
FOR EACH ROW
EXECUTE FUNCTION delete_related_orders();

/*
SELECT count(*) from coffee_order;

DELETE FROM Customer
WHERE Customer_ID = 1;

SELECT count(*) from coffee_order;
*/


CREATE OR REPLACE FUNCTION assign_initial_order_status()
RETURNS TRIGGER AS
$$
BEGIN
    NEW.Order_Status_ID := 1;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Триггер присвоения статуса заказа по умолчанию при создании заказа
CREATE TRIGGER trigger_assign_initial_order_status
BEFORE INSERT ON Coffee_Order
FOR EACH ROW
EXECUTE FUNCTION assign_initial_order_status();

/*
SELECT coffee_order.order_status_id from coffee_order;

INSERT INTO Coffee_Order (Coffee_Order_ID, Customer_ID, Batch_ID, Port_ID, Order_Status_ID)
VALUES (5, 2, 3, 4, NULL);

SELECT coffee_order_id, order_status_id from coffee_order;
*/

