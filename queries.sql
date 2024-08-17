-- EXAMPLES OF COMMON QUERIES USED 

-- VIEWS
-- View ingredients ordered by category, name
SELECT * FROM  "ingredients_ordered";
SELECT * FROM  "orders_summary";
SELECT * FROM  "menu_items_availability";
SELECT * FROM  "menu_items_profit";
SELECT * FROM  "total_sales_value";
SELECT * FROM  "best_selling_food";

EXPLAIN QUERY PLAN

-- OTHER

-- View bank account
SELECT * FROM "bank_account";

-- Initialize bank account with cash.
INSERT INTO "bank_account" ("net_cash", "vat_due") VALUES (10000.0, 0.0);

-- View suppliers
SELECT * FROM "suppliers";

-- View menu items
SELECT * FROM "menu_items";

-- Insert a new supplier
INSERT INTO "suppliers" ("name", "category", "contact_number", "contact_mail", "delivery_days") VALUES
('Green Grocer', 'Fruit and Veg', 998877665, 'info@greengrocer.com', 'Monday,Tuesday,Wednesday,Thursday,Friday,Saturday');

-- Insert a new ingredient
INSERT INTO "ingredients" ("name", "category", "inventory_count", "allergens") VALUES
('Lettuce', 'Fruit and Veg', 0, '');

-- Connect ingredient with a supplier
INSERT INTO "suppliers_ingredients" ("supplier_id", "ingredient_id", "unit_of_measure", "price_per_unit") VALUES
((SELECT "id" FROM "suppliers" WHERE "name" = 'Green Grocer'), (SELECT "id" FROM "ingredients" WHERE "name" = 'Lettuce'), 'kg', 2.0);

-- Insert a new order by selecting the supplier_id based on the "supplier's name"
INSERT INTO "orders" ("supplier_id")
SELECT "id" FROM "suppliers" WHERE "name" = 'Supplier Name';
-- Insert items into the order
-- The "total_value" in "orders" and "inventory_count" in "ingredients" will be automatically updated by the trigger
INSERT INTO "order_items" ("order_id", "ingredient_id", "quantity") VALUES (last_insert_rowid(), 1, 2.5);
INSERT INTO "order_items" ("order_id", "ingredient_id", "quantity") VALUES (last_insert_rowid(), 2, 1.0);

-- Add new menu item
INSERT INTO "menu_items" ("name", "price", "type") VALUES
('Greek Salad', 8.99, 'food');

-- Connect menu item with ingredients
INSERT INTO "dishes_ingredients" ("menu_item_id", "ingredient_id", "quantity") VALUES
((SELECT "id" FROM "menu_items" WHERE "name" = 'Greek Salad'), (SELECT "id" FROM "ingredients" WHERE "name" = 'Lettuce'), 0.2);

-- Add new sale
INSERT INTO "sales" ("sale_date") VALUES (CURRENT_TIMESTAMP);
-- Connect menu item with the latest sale.
INSERT INTO "sales_items" ("sale_id", "menu_item_id", "quantity") VALUES
((SELECT "id" FROM "sales" ORDER BY "id" DESC LIMIT 1), 1, 5);
