-- Index to speed up search by product name
CREATE INDEX idx_products_name ON Products(name);

-- Index to quickly filter products by category
CREATE INDEX idx_products_category ON Products(category_id);

-- Index to quickly find products by seller
CREATE INDEX idx_products_seller ON Products(seller_id);

-- Index to speed up queries fetching orders for a specific user
CREATE INDEX idx_orders_user ON Orders(user_id);

-- Index to quickly filter orders by their status (Pending, Shipped, etc.)
CREATE INDEX idx_orders_status ON Orders(status);

-- Index to speed up fetching all items of a specific order
CREATE INDEX idx_orderitems_order ON OrderItems(order_id);

-- Index to quickly find all orders that include a specific product
CREATE INDEX idx_orderitems_product ON OrderItems(product_id);

-- Index to quickly fetch all reviews for a particular product
CREATE INDEX idx_reviews_product ON Reviews(product_id);

-- Index to quickly fetch all reviews written by a particular user
CREATE INDEX idx_reviews_user ON Reviews(user_id);

-- Index to speed up fetching payments associated with a specific order
CREATE INDEX idx_payments_order ON Payments(order_id);
