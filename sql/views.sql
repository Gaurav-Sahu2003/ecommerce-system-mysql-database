-- 1. Active Orders
CREATE VIEW v_active_orders AS SELECT * FROM Orders WHERE status IN('pending','paid','shipped');

-- 2. Product Ratings
CREATE VIEW v_product_ratings AS
SELECT p.name,AVG(r.rating) avg_rating FROM Products p LEFT JOIN Reviews r
ON p.product_id=r.product_id GROUP BY p.product_id;

-- 3. Customer Wallets
CREATE VIEW v_customer_wallets AS SELECT name,wallet FROM Users WHERE role='customer';

-- 4. Seller Products
CREATE VIEW v_seller_products AS SELECT u.name seller,p.name product,p.stock FROM Products p JOIN Users u ON p.seller_id=u.user_id;

-- 5. Order Details
CREATE VIEW v_order_details AS SELECT o.order_id,u.name,p.name,oi.quantity FROM Orders o
JOIN OrderItems oi ON o.order_id=oi.order_id
JOIN Products p ON oi.product_id=p.product_id
JOIN Users u ON o.user_id=u.user_id;

-- 6. Revenue by Category
CREATE VIEW v_category_revenue AS
SELECT c.name,SUM(oi.quantity*oi.unit_price) revenue
FROM OrderItems oi JOIN Products p ON oi.product_id=p.product_id
JOIN Categories c ON p.category_id=c.category_id
GROUP BY c.name;

-- 7. Coupon Usage
CREATE VIEW v_coupon_usage AS
SELECT c.code,COUNT(o.order_id) times_used FROM Orders o
JOIN Coupons c ON o.total_amount<o.total_amount+1 -- dummy link
GROUP BY c.code;

-- 8. Stock Ledger Latest
CREATE VIEW v_stock_ledger AS SELECT * FROM StockLedger ORDER BY created_at DESC;

-- 9. Payments Summary
CREATE VIEW v_payments_summary AS SELECT status,COUNT(*) cnt,SUM(amount) amt FROM Payments GROUP BY status;

-- 10. Top Customers
CREATE VIEW v_top_customers AS
SELECT u.name,SUM(o.total_amount) spent FROM Orders o JOIN Users u ON o.user_id=u.user_id
GROUP BY u.user_id ORDER BY spent DESC LIMIT 10;
