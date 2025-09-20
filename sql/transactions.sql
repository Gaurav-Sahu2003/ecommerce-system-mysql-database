-- 1. Place Order (simplified)
START TRANSACTION;
INSERT INTO Orders(user_id,order_date,status,total_amount) VALUES (1,CURDATE(),'pending',0);
SET @oid=LAST_INSERT_ID();
INSERT INTO OrderItems(order_id,product_id,quantity,unit_price) VALUES(@oid,1,1,12000);
UPDATE Products SET stock=stock-1 WHERE product_id=1;
UPDATE Orders SET total_amount=12000 WHERE order_id=@oid;
COMMIT;

-- 2. Cancel Order
START TRANSACTION;
UPDATE Orders SET status='cancelled' WHERE order_id=1;
UPDATE Payments SET status='failed' WHERE order_id=1;
COMMIT;

-- 3. Add Funds to Wallet
START TRANSACTION;
UPDATE Users SET wallet=wallet+1000 WHERE user_id=1;
COMMIT;

-- 4. Transfer Wallet to Order
START TRANSACTION;
UPDATE Users SET wallet=wallet-500 WHERE user_id=1;
UPDATE Orders SET total_amount=total_amount-500 WHERE order_id=1;
COMMIT;

-- 5. Bulk Insert Products
START TRANSACTION;
INSERT INTO Products(name,price,stock,category_id,seller_id) VALUES ('Charger',500,20,3,2);
INSERT INTO Products(name,price,stock,category_id,seller_id) VALUES ('Cover',300,50,3,2);
COMMIT;

-- 6. Refund with Wallet
START TRANSACTION;
UPDATE Orders SET status='cancelled' WHERE order_id=2;
UPDATE Users SET wallet=wallet+2000 WHERE user_id=1;
COMMIT;

-- 7. Mark Delivered
START TRANSACTION;
UPDATE Orders SET status='delivered' WHERE order_id=1;
COMMIT;

-- 8. Add Coupon & Apply
START TRANSACTION;
INSERT INTO Coupons(code,discount_percent,valid_until) VALUES('FESTIVE20',20,'2026-01-01');
UPDATE Orders SET total_amount=total_amount*0.8 WHERE order_id=1;
COMMIT;

-- 9. Pay Order
START TRANSACTION;
UPDATE Payments SET status='completed' WHERE order_id=1;
UPDATE Orders SET status='paid' WHERE order_id=1;
COMMIT;

-- 10. Delete Product Safely
START TRANSACTION;
DELETE FROM Reviews WHERE product_id=3;
DELETE FROM Products WHERE product_id=3;
COMMIT;
