-- 1️⃣ Create the database
CREATE DATABASE IF NOT EXISTS ecommerce_system;

-- 2️⃣ Use the database
USE ecommerce_system;

CREATE TABLE Users (
  user_id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100),
  email VARCHAR(100) UNIQUE,
  password_hash VARCHAR(255),
  role ENUM('Customer','Admin','Seller'),
  address TEXT,
  wallet_balance DECIMAL(10,2)
);

CREATE TABLE Categories (
  category_id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100),
  parent_category_id INT,
  FOREIGN KEY (parent_category_id) REFERENCES Categories(category_id)
);

CREATE TABLE Products (
  product_id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100),
  description TEXT,
  price DECIMAL(10,2),
  stock INT,
  category_id INT,
  seller_id INT,
  FOREIGN KEY (category_id) REFERENCES Categories(category_id),
  FOREIGN KEY (seller_id) REFERENCES Users(user_id)
);

CREATE TABLE Orders (
  order_id INT PRIMARY KEY AUTO_INCREMENT,
  user_id INT,
  order_date DATETIME,
  status ENUM('Pending','Shipped','Delivered','Returned','Cancelled'),
  payment_method ENUM('Cash','Card','Wallet'),
  total_amount DECIMAL(10,2),
  FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE OrderItems (
  order_item_id INT PRIMARY KEY AUTO_INCREMENT,
  order_id INT,
  product_id INT,
  quantity INT,
  price DECIMAL(10,2),
  FOREIGN KEY (order_id) REFERENCES Orders(order_id),
  FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

CREATE TABLE Payments (
  payment_id INT PRIMARY KEY AUTO_INCREMENT,
  order_id INT,
  amount DECIMAL(10,2),
  payment_date DATETIME,
  status ENUM('Success','Failed','Refunded'),
  FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

CREATE TABLE Reviews (
  review_id INT PRIMARY KEY AUTO_INCREMENT,
  product_id INT,
  user_id INT,
  rating INT,
  comment TEXT,
  review_date DATETIME,
  FOREIGN KEY (product_id) REFERENCES Products(product_id),
  FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE Cart (
  cart_id INT PRIMARY KEY AUTO_INCREMENT,
  user_id INT,
  created_at DATETIME,
  FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE CartItems (
  cart_item_id INT PRIMARY KEY AUTO_INCREMENT,
  cart_id INT,
  product_id INT,
  quantity INT,
  FOREIGN KEY (cart_id) REFERENCES Cart(cart_id),
  FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

CREATE TABLE Coupons (
  coupon_id INT PRIMARY KEY AUTO_INCREMENT,
  code VARCHAR(50),
  discount_percent INT,
  expiry_date DATE
);

CREATE TABLE CouponUsage (
  usage_id INT PRIMARY KEY AUTO_INCREMENT,
  coupon_id INT,
  user_id INT,
  order_id INT,
  used_on DATETIME,
  FOREIGN KEY (coupon_id) REFERENCES Coupons(coupon_id),
  FOREIGN KEY (user_id) REFERENCES Users(user_id),
  FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

CREATE TABLE Inventory_Audit (
  audit_id INT PRIMARY KEY AUTO_INCREMENT,
  product_id INT,
  action VARCHAR(50),
  quantity_changed INT,
  action_date DATETIME,
  user_id INT,
  FOREIGN KEY (product_id) REFERENCES Products(product_id),
  FOREIGN KEY (user_id) REFERENCES Users(user_id)
);
