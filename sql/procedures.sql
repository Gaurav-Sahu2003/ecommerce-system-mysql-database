-- 1. Monthly Sales Report
CREATE PROCEDURE sp_monthly_sales(IN yr INT,IN mn INT)
BEGIN
  SELECT DATE(order_date),SUM(total_amount) FROM Orders
  WHERE YEAR(order_date)=yr AND MONTH(order_date)=mn
  GROUP BY DATE(order_date);
END;

-- 2. Best Selling Products
CREATE PROCEDURE sp_best_sellers()
BEGIN
  SELECT p.name,SUM(oi.quantity) as sold FROM OrderItems oi
  JOIN Products p ON oi.product_id=p.product_id
  GROUP BY p.name ORDER BY sold DESC LIMIT 10;
END;

-- 3. Add New Product
CREATE PROCEDURE sp_add_product(IN n VARCHAR(100),IN pr DECIMAL(10,2),IN st INT,IN c INT,IN s INT)
BEGIN
  INSERT INTO Products(name,price,stock,category_id,seller_id)
  VALUES (n,pr,st,c,s);
END;

-- 4. Apply Coupon
CREATE PROCEDURE sp_apply_coupon(IN o INT,IN c VARCHAR(50))
BEGIN
  DECLARE disc DECIMAL(5,2);
  SELECT discount_percent INTO disc FROM Coupons WHERE code=c;
  UPDATE Orders SET total_amount=total_amount-(total_amount*disc/100) WHERE order_id=o;
END;

-- 5. Get Low Stock Products
CREATE PROCEDURE sp_low_stock()
BEGIN
  SELECT * FROM Products WHERE stock<10;
END;

-- 6. Customer Order History
CREATE PROCEDURE sp_customer_orders(IN uid INT)
BEGIN
  SELECT * FROM Orders WHERE user_id=uid;
END;

-- 7. Top Rated Products
CREATE PROCEDURE sp_top_rated()
BEGIN
  SELECT p.name,AVG(r.rating) avg_rating FROM Reviews r
  JOIN Products p ON r.product_id=p.product_id
  GROUP BY p.product_id ORDER BY avg_rating DESC LIMIT 10;
END;

-- 8. Refund Order
CREATE PROCEDURE sp_refund(IN oid INT)
BEGIN
  UPDATE Orders SET status='cancelled' WHERE order_id=oid;
  UPDATE Payments SET status='failed' WHERE order_id=oid;
END;

-- 9. Search Product
CREATE PROCEDURE sp_search_product(IN keyword VARCHAR(50))
BEGIN
  SELECT * FROM Products WHERE name LIKE CONCAT('%',keyword,'%');
END;

-- 10. Daily Revenue
CREATE PROCEDURE sp_daily_revenue(IN dt DATE)
BEGIN
  SELECT SUM(total_amount) FROM Orders WHERE order_date=dt;
END;
