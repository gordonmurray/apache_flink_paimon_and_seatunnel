CREATE DATABASE IF NOT EXISTS mydatabase;

USE mydatabase;

CREATE TABLE IF NOT EXISTS products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    price DECIMAL(10,2) NOT NULL
);

INSERT INTO products (name, price) VALUES
    ('Organic Almond Butter', 10.99),
    ('Whole Grain Bread', 3.49),
    ('Cold Pressed Olive Oil', 15.99),
    ('Gluten Free Pasta', 2.99),
    ('Organic Coconut Milk', 2.49),
    ('Free Range Eggs', 4.99),
    ('Grass Fed Beef', 8.99),
    ('Fresh Atlantic Salmon', 19.99),
    ('Alkaline Water', 1.49),
    ('Organic Green Tea', 6.99),
    ('Vegan Protein Powder', 24.99),
    ('Unsweetened Cocoa Powder', 7.99),
    ('Organic Blueberries', 4.49),
    ('Soy Milk', 2.99),
    ('Raw Honey', 9.99),
    ('Unsalted Mixed Nuts', 11.99),
    ('Quinoa', 5.99),
    ('Gluten Free Flour', 4.99),
    ('Organic Kale', 3.99),
    ('Almond Milk', 2.99),
    ('Organic Chia Seeds', 8.99),
    ('Einkorn Flour', 6.99),
    ('Himalayan Pink Salt', 2.99),
    ('Organic Pumpkin Seeds', 7.99),
    ('Kombucha', 3.99),
    ('Organic Spelt Flour', 5.49),
    ('Dairy Free Chocolate Chips', 4.99),
    ('Organic Apple Cider Vinegar', 3.99),
    ('Sprouted Brown Rice', 4.99),
    ('Cage Free Chicken Breast', 9.99);
