-- These are values that allow for the testing of the database.

-- ADD SUPPLIERS
INSERT INTO suppliers (name, category, contact_number, contact_mail, delivery_days) VALUES
('Green Grocer', 'Fruit and Veg', 998877665, 'info@greengrocer.com', 'Monday,Tuesday,Wednesday,Thursday,Friday,Saturday'),
('Organic Farms', 'Fruit and Veg', 887766554, 'sales@organicfarms.com', 'Monday,Wednesday,Friday,Saturday'),
('Dairy Delight', 'Dairy', 112233445, 'sales@dairydelight.com', 'Monday,Wednesday,Friday,Saturday'),
('Pantry Essentials', 'Dry store', 554433221, 'sales@pantryessentials.com', 'Monday,Tuesday,Thursday,Friday');

-- ADD INGREDIENTS
INSERT INTO ingredients (name, category, inventory_count, allergens) VALUES
('Lettuce', 'Fruit and Veg', 0, ''),
('Tomatoes', 'Fruit and Veg', 0, ''),
('Cucumbers', 'Fruit and Veg', 0, ''),
('Carrots', 'Fruit and Veg', 0, ''),
('Red Onion', 'Fruit and Veg', 0, ''),
('Bell Peppers', 'Fruit and Veg', 0, ''),
('Feta Cheese', 'Dairy', 0, 'Dairy, Not Vegan'),
('Olives', 'Dry store', 0, ''),
('Chickpeas', 'Dry store', 0, ''),
('Quinoa', 'Dry store', 0, 'Gluten'),
('Mozzarella', 'Dairy', 0, 'Dairy, Not Vegan'),
('Spinach', 'Fruit and Veg', 0, ''),
('Avocado', 'Fruit and Veg', 0, ''),
('Walnuts', 'Dry store', 0, 'Nuts');

-- ADD MENU ITEMS
INSERT INTO menu_items (name, price, type) VALUES
('Greek Salad', 8.99, 'food'),
('Quinoa Salad', 9.99, 'food'),
('Spinach Avocado Salad', 10.99, 'food'),
('Classic Caesar Salad', 7.99, 'food'),
('Mozzarella Tomato Salad', 8.49, 'food'),
('Mixed Veggie Salad', 7.49, 'food');

-- CONNECT INGREDIENTS WITH SUPPLIERS

INSERT INTO suppliers_ingredients (supplier_id, ingredient_id, unit_of_measure, price_per_unit) VALUES
((SELECT id FROM suppliers WHERE name = 'Green Grocer'), (SELECT id FROM ingredients WHERE name = 'Lettuce'), 'kg', 2.0),
((SELECT id FROM suppliers WHERE name = 'Organic Farms'), (SELECT id FROM ingredients WHERE name = 'Lettuce'), 'kg', 2.2),
((SELECT id FROM suppliers WHERE name = 'Green Grocer'), (SELECT id FROM ingredients WHERE name = 'Tomatoes'), 'kg', 3.0),
((SELECT id FROM suppliers WHERE name = 'Organic Farms'), (SELECT id FROM ingredients WHERE name = 'Tomatoes'), 'kg', 3.2),
((SELECT id FROM suppliers WHERE name = 'Green Grocer'), (SELECT id FROM ingredients WHERE name = 'Cucumbers'), 'kg', 1.9),
((SELECT id FROM suppliers WHERE name = 'Organic Farms'), (SELECT id FROM ingredients WHERE name = 'Cucumbers'), 'kg', 1.8),
((SELECT id FROM suppliers WHERE name = 'Green Grocer'), (SELECT id FROM ingredients WHERE name = 'Carrots'), 'kg', 2.5),
((SELECT id FROM suppliers WHERE name = 'Organic Farms'), (SELECT id FROM ingredients WHERE name = 'Carrots'), 'kg', 2.6),
((SELECT id FROM suppliers WHERE name = 'Organic Farms'), (SELECT id FROM ingredients WHERE name = 'Red Onion'), 'kg', 1.5),
((SELECT id FROM suppliers WHERE name = 'Green Grocer'), (SELECT id FROM ingredients WHERE name = 'Red Onion'), 'kg', 1.6),
((SELECT id FROM suppliers WHERE name = 'Green Grocer'), (SELECT id FROM ingredients WHERE name = 'Bell Peppers'), 'kg', 4.0),
((SELECT id FROM suppliers WHERE name = 'Organic Farms'), (SELECT id FROM ingredients WHERE name = 'Bell Peppers'), 'kg', 4.2),
((SELECT id FROM suppliers WHERE name = 'Organic Farms'), (SELECT id FROM ingredients WHERE name = 'Spinach'), 'kg', 3.0),
((SELECT id FROM suppliers WHERE name = 'Green Grocer'), (SELECT id FROM ingredients WHERE name = 'Spinach'), 'kg', 3.1),
((SELECT id FROM suppliers WHERE name = 'Organic Farms'), (SELECT id FROM ingredients WHERE name = 'Avocado'), 'kg', 12.0),
((SELECT id FROM suppliers WHERE name = 'Green Grocer'), (SELECT id FROM ingredients WHERE name = 'Avocado'), 'kg', 12.5),
((SELECT id FROM suppliers WHERE name = 'Dairy Delight'), (SELECT id FROM ingredients WHERE name = 'Feta Cheese'), 'kg', 10.0),
((SELECT id FROM suppliers WHERE name = 'Pantry Essentials'), (SELECT id FROM ingredients WHERE name = 'Olives'), 'kg', 5.0),
((SELECT id FROM suppliers WHERE name = 'Pantry Essentials'), (SELECT id FROM ingredients WHERE name = 'Chickpeas'), 'kg', 3.5),
((SELECT id FROM suppliers WHERE name = 'Pantry Essentials'), (SELECT id FROM ingredients WHERE name = 'Quinoa'), 'kg', 6.0),
((SELECT id FROM suppliers WHERE name = 'Dairy Delight'), (SELECT id FROM ingredients WHERE name = 'Mozzarella'), 'kg', 8.0),
((SELECT id FROM suppliers WHERE name = 'Pantry Essentials'), (SELECT id FROM ingredients WHERE name = 'Walnuts'), 'kg', 15.0);


-- Greek Salad: Lettuce, Tomatoes, Cucumbers, Red Onion, Feta Cheese, Olives
INSERT INTO dishes_ingredients (menu_item_id, ingredient_id, quantity) VALUES
((SELECT id FROM menu_items WHERE name = 'Greek Salad'), (SELECT id FROM ingredients WHERE name = 'Lettuce'), 0.2),
((SELECT id FROM menu_items WHERE name = 'Greek Salad'), (SELECT id FROM ingredients WHERE name = 'Tomatoes'), 0.15),
((SELECT id FROM menu_items WHERE name = 'Greek Salad'), (SELECT id FROM ingredients WHERE name = 'Cucumbers'), 0.1),
((SELECT id FROM menu_items WHERE name = 'Greek Salad'), (SELECT id FROM ingredients WHERE name = 'Red Onion'), 0.05),
((SELECT id FROM menu_items WHERE name = 'Greek Salad'), (SELECT id FROM ingredients WHERE name = 'Feta Cheese'), 0.1),
((SELECT id FROM menu_items WHERE name = 'Greek Salad'), (SELECT id FROM ingredients WHERE name = 'Olives'), 0.05);

-- Quinoa Salad: Quinoa, Cucumbers, Bell Peppers, Feta Cheese, Chickpeas
INSERT INTO dishes_ingredients (menu_item_id, ingredient_id, quantity) VALUES
((SELECT id FROM menu_items WHERE name = 'Quinoa Salad'), (SELECT id FROM ingredients WHERE name = 'Quinoa'), 0.1),
((SELECT id FROM menu_items WHERE name = 'Quinoa Salad'), (SELECT id FROM ingredients WHERE name = 'Cucumbers'), 0.1),
((SELECT id FROM menu_items WHERE name = 'Quinoa Salad'), (SELECT id FROM ingredients WHERE name = 'Bell Peppers'), 0.1),
((SELECT id FROM menu_items WHERE name = 'Quinoa Salad'), (SELECT id FROM ingredients WHERE name = 'Feta Cheese'), 0.1),
((SELECT id FROM menu_items WHERE name = 'Quinoa Salad'), (SELECT id FROM ingredients WHERE name = 'Chickpeas'), 0.1);

-- Spinach Avocado Salad: Spinach, Avocado, Walnuts
INSERT INTO dishes_ingredients (menu_item_id, ingredient_id, quantity) VALUES
((SELECT id FROM menu_items WHERE name = 'Spinach Avocado Salad'), (SELECT id FROM ingredients WHERE name = 'Spinach'), 0.15),
((SELECT id FROM menu_items WHERE name = 'Spinach Avocado Salad'), (SELECT id FROM ingredients WHERE name = 'Avocado'), 0.1),
((SELECT id FROM menu_items WHERE name = 'Spinach Avocado Salad'), (SELECT id FROM ingredients WHERE name = 'Walnuts'), 0.05);

-- Classic Caesar Salad: Lettuce, Feta Cheese, Cucumbers
INSERT INTO dishes_ingredients (menu_item_id, ingredient_id, quantity) VALUES
((SELECT id FROM menu_items WHERE name = 'Classic Caesar Salad'), (SELECT id FROM ingredients WHERE name = 'Lettuce'), 0.2),
((SELECT id FROM menu_items WHERE name = 'Classic Caesar Salad'), (SELECT id FROM ingredients WHERE name = 'Feta Cheese'), 0.1),
((SELECT id FROM menu_items WHERE name = 'Classic Caesar Salad'), (SELECT id FROM ingredients WHERE name = 'Cucumbers'), 0.1);

-- Mozzarella Tomato Salad: Mozzarella, Tomatoes, Spinach
INSERT INTO dishes_ingredients (menu_item_id, ingredient_id, quantity) VALUES
((SELECT id FROM menu_items WHERE name = 'Mozzarella Tomato Salad'), (SELECT id FROM ingredients WHERE name = 'Mozzarella'), 0.15),
((SELECT id FROM menu_items WHERE name = 'Mozzarella Tomato Salad'), (SELECT id FROM ingredients WHERE name = 'Tomatoes'), 0.2),
((SELECT id FROM menu_items WHERE name = 'Mozzarella Tomato Salad'), (SELECT id FROM ingredients WHERE name = 'Spinach'), 0.1);

-- Mixed Veggie Salad: Lettuce, Carrots, Bell Peppers, Red Onion
INSERT INTO dishes_ingredients (menu_item_id, ingredient_id, quantity) VALUES
((SELECT id FROM menu_items WHERE name = 'Mixed Veggie Salad'), (SELECT id FROM ingredients WHERE name = 'Lettuce'), 0.2),
((SELECT id FROM menu_items WHERE name = 'Mixed Veggie Salad'), (SELECT id FROM ingredients WHERE name = 'Carrots'), 0.1),
((SELECT id FROM menu_items WHERE name = 'Mixed Veggie Salad'), (SELECT id FROM ingredients WHERE name = 'Bell Peppers'), 0.1),
((SELECT id FROM menu_items WHERE name = 'Mixed Veggie Salad'), (SELECT id FROM ingredients WHERE name = 'Red Onion'), 0.05);

-- CREATE ORDERS WITH SUPPLIERS
INSERT INTO orders (supplier_id) VALUES
((SELECT id FROM suppliers WHERE name = 'Green Grocer')),
((SELECT id FROM suppliers WHERE name = 'Organic Farms')),
((SELECT id FROM suppliers WHERE name = 'Dairy Delight')),
((SELECT id FROM suppliers WHERE name = 'Pantry Essentials'));

-- ADD INGREDIENTS WITH SUPPLIERS
INSERT INTO order_items (order_id, ingredient_id, quantity) VALUES
((SELECT id FROM orders ORDER BY id DESC LIMIT 1 OFFSET 3), (SELECT id FROM ingredients WHERE name = 'Lettuce'), 10),
((SELECT id FROM orders ORDER BY id DESC LIMIT 1 OFFSET 3), (SELECT id FROM ingredients WHERE name = 'Tomatoes'), 15),
((SELECT id FROM orders ORDER BY id DESC LIMIT 1 OFFSET 3), (SELECT id FROM ingredients WHERE name = 'Cucumbers'), 12),
((SELECT id FROM orders ORDER BY id DESC LIMIT 1 OFFSET 3), (SELECT id FROM ingredients WHERE name = 'Avocado'), 6),

((SELECT id FROM orders ORDER BY id DESC LIMIT 1 OFFSET 2), (SELECT id FROM ingredients WHERE name = 'Carrots'), 20),
((SELECT id FROM orders ORDER BY id DESC LIMIT 1 OFFSET 2), (SELECT id FROM ingredients WHERE name = 'Red Onion'), 8),
((SELECT id FROM orders ORDER BY id DESC LIMIT 1 OFFSET 2), (SELECT id FROM ingredients WHERE name = 'Spinach'), 10),
((SELECT id FROM orders ORDER BY id DESC LIMIT 1 OFFSET 2), (SELECT id FROM ingredients WHERE name = 'Bell Peppers'), 5),

((SELECT id FROM orders ORDER BY id DESC LIMIT 1 OFFSET 1), (SELECT id FROM ingredients WHERE name = 'Feta Cheese'), 5),
((SELECT id FROM orders ORDER BY id DESC LIMIT 1 OFFSET 1), (SELECT id FROM ingredients WHERE name = 'Mozzarella'), 7),

((SELECT id FROM orders ORDER BY id DESC LIMIT 1 OFFSET 0), (SELECT id FROM ingredients WHERE name = 'Olives'), 10),
((SELECT id FROM orders ORDER BY id DESC LIMIT 1 OFFSET 0), (SELECT id FROM ingredients WHERE name = 'Chickpeas'), 12),
((SELECT id FROM orders ORDER BY id DESC LIMIT 1 OFFSET 0), (SELECT id FROM ingredients WHERE name = 'Quinoa'), 6),
((SELECT id FROM orders ORDER BY id DESC LIMIT 1 OFFSET 0), (SELECT id FROM ingredients WHERE name = 'Walnuts'), 3);

-- CREATE SALE
INSERT INTO sales (sale_date) VALUES (CURRENT_TIMESTAMP);
-- CONNECT MENU ITEMS WITH THE PARTICULAR SALE
INSERT INTO sales_items (sale_id, menu_item_id, quantity) VALUES
((SELECT id FROM sales ORDER BY id DESC LIMIT 1), 1, 5),
((SELECT id FROM sales ORDER BY id DESC LIMIT 1), 2, 3),
((SELECT id FROM sales ORDER BY id DESC LIMIT 1), 5, 3),
((SELECT id FROM sales ORDER BY id DESC LIMIT 1), 6, 4),
((SELECT id FROM sales ORDER BY id DESC LIMIT 1), 3, 6);

-- CHECK BANK ACCOUNT BALANCE
SELECT * FROM bank_account;
