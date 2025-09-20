-- 1. Reduce stock when order item inserted
CREATE TRIGGER trg_reduce_stock AFTER INSERT ON OrderItems
FOR EACH ROW
UPDATE Products SET stock = stock - NEW.quantity WHERE product_id = NEW.product_id;

-- 2. Log stock changes
CREATE TRIGGER trg_log_stock AFTER UPDATE ON Products
FOR EACH ROW
INSERT INTO StockLedger(product_id,change_qty,reason)
VALUES (NEW.product_id, NEW.stock-OLD.stock, 'manual update');

-- 3. Prevent negative stock
CREATE TRIGGER trg_no_negative_stock BEFORE UPDATE ON Products
FOR EACH ROW
IF NEW.stock < 0 THEN SET NEW.stock = 0; END IF;

-- 4. Low stock alert
CREATE TRIGGER trg_low_stock AFTER UPDATE ON Products
FOR EACH ROW
IF NEW.stock < 5 THEN
  INSERT INTO Alerts(product_id,message) VALUES (NEW.product_id,'Low stock alert!');
END IF;

-- 5. Update order total automatically
CREATE TRIGGER trg_update_order_total AFTER INSERT ON OrderItems
FOR EACH ROW
UPDATE Orders SET total_amount = total_amount + (NEW.unit_price*NEW.quantity)
WHERE order_id = NEW.order_id;

-- 6. Refund wallet on cancelled order
CREATE TRIGGER trg_refund_wallet AFTER UPDATE ON Orders
FOR EACH ROW
IF NEW.status='cancelled' THEN
  UPDATE Users SET wallet=wallet+OLD.total_amount WHERE user_id=OLD.user_id;
END IF;

-- 7. Delete reviews when product deleted
CREATE TRIGGER trg_delete_reviews AFTER DELETE ON Products
FOR EACH ROW
DELETE FROM Reviews WHERE product_id=OLD.product_id;

-- 8. Auto payment record on order paid
CREATE TRIGGER trg_auto_payment AFTER UPDATE ON Orders
FOR EACH ROW
IF NEW.status='paid' THEN
  INSERT INTO Payments(order_id,amount,status) VALUES (NEW.order_id,NEW.total_amount,'completed');
END IF;

-- 9. Alert for refunded payments
CREATE TRIGGER trg_payment_refund AFTER UPDATE ON Payments
FOR EACH ROW
IF NEW.status='failed' THEN
  INSERT INTO Alerts(product_id,message) VALUES (NULL,'Payment failed for order');
END IF;

-- 10. Track coupon expiry
CREATE TRIGGER trg_coupon_expiry AFTER UPDATE ON Coupons
FOR EACH ROW
IF NEW.valid_until<CURDATE() THEN
  INSERT INTO Alerts(product_id,message) VALUES (NULL,'Coupon expired');
END IF;
