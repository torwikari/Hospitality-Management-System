-- Bank account, including net cash and VAT due
CREATE TABLE IF NOT EXISTS "bank_account" (
    "id" INTEGER PRIMARY KEY,
    "net_cash" REAL NOT NULL DEFAULT 0.0,  -- Tracks the net cash balance
    "vat_due" REAL NOT NULL DEFAULT 0.0    -- Tracks the VAT liability
);
-- Example starting values for bank_account.
INSERT INTO bank_account (net_cash, vat_due) VALUES (10000.0, 0.0);

-- SUPPLIERS --
CREATE TABLE IF NOT EXISTS "suppliers" (
    "id" INTEGER NOT NULL UNIQUE,
    "name" TEXT NOT NULL,
    "category" TEXT NOT NULL,
    "contact_number" INTEGER NOT NULL,
    "contact_mail" TEXT NOT NULL,
    "delivery_days" TEXT NOT NULL,
    PRIMARY KEY("id")
);

-- Junction table between suppliers and ingredients
CREATE TABLE IF NOT EXISTS "suppliers_ingredients" (
    "supplier_id" INTEGER NOT NULL,
    "ingredient_id" INTEGER NOT NULL,
    "unit_of_measure" TEXT NOT NULL,
    "price_per_unit" REAL NOT NULL,
    PRIMARY KEY("supplier_id", "ingredient_id"),
    FOREIGN KEY("supplier_id") REFERENCES "suppliers"("id"),
    FOREIGN KEY("ingredient_id") REFERENCES "ingredients"("id")
);

-- INGREDIENTS
CREATE TABLE IF NOT EXISTS "ingredients" (
    "id" INTEGER NOT NULL,
    "name" TEXT NOT NULL,
    "category" TEXT NOT NULL,
    "inventory_count" REAL NOT NULL DEFAULT 0.0,
    "allergens" TEXT,
    PRIMARY KEY("id")
);

-- MENU ITEMS
CREATE TABLE IF NOT EXISTS "menu_items" (
    "id" INTEGER NOT NULL,
    "name" TEXT NOT NULL,
    "price" REAL NOT NULL, -- Price on the menu
    "type" TEXT NOT NULL,
    "total_quantity_sold" INTEGER DEFAULT 0,
    CHECK ("type" IN ("food", "beverage")),
    PRIMARY KEY("id")
);

-- Junction table between dishes and ingredients
CREATE TABLE IF NOT EXISTS "dishes_ingredients" (
    "menu_item_id" INTEGER NOT NULL,
    "ingredient_id" INTEGER NOT NULL,
    "quantity" REAL NOT NULL,
    PRIMARY KEY("menu_item_id", "ingredient_id"),
    FOREIGN KEY("menu_item_id") REFERENCES "menu_items"("id"),
    FOREIGN KEY("ingredient_id") REFERENCES "ingredients"("id")
);

-- ORDERS TABLES --

CREATE TABLE IF NOT EXISTS "orders" (
    "id" INTEGER NOT NULL,
    "supplier_id" INTEGER NOT NULL,
    "order_date" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "total_value" REAL DEFAULT 0.0,
    PRIMARY KEY("id"),
    FOREIGN KEY("supplier_id") REFERENCES "suppliers"("id")
);

CREATE TABLE IF NOT EXISTS "order_items" (
    "order_id" INTEGER NOT NULL,
    "ingredient_id" INTEGER NOT NULL,
    "quantity" REAL NOT NULL,
    PRIMARY KEY("order_id", "ingredient_id"),
    FOREIGN KEY("order_id") REFERENCES "orders"("id"),
    FOREIGN KEY("ingredient_id") REFERENCES "ingredients"("id")
);

-- SALES --

-- Table to store sales
CREATE TABLE IF NOT EXISTS "sales" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    "sale_date" TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- Junction table to link sales with menu items
CREATE TABLE IF NOT EXISTS "sales_items" (
    "sale_id" INTEGER NOT NULL,
    "menu_item_id" INTEGER NOT NULL,
    "quantity" REAL NOT NULL,
    PRIMARY KEY("sale_id", "menu_item_id"),
    FOREIGN KEY("sale_id") REFERENCES "sales"("id"),
    FOREIGN KEY("menu_item_id") REFERENCES "menu_items"("id")
);

-- TRIGGERS

-- Trigger (orders) to update the total value of the order, inventory count of ingredients, and bank_account
CREATE TRIGGER IF NOT EXISTS "update_order_inventory_bank_account"
AFTER INSERT ON "order_items"
BEGIN
    -- Update the total value of the order and inventory in a single transaction
    UPDATE "orders"
    SET "total_value" = (
        SELECT SUM("oi"."quantity" * "si"."price_per_unit")
        FROM "order_items" AS "oi"
        JOIN "suppliers_ingredients" AS "si" ON "oi"."ingredient_id" = "si"."ingredient_id"
        WHERE "oi"."order_id" = NEW."order_id"
    )
    WHERE "id" = NEW."order_id";

    -- Update the inventory count for each ingredient in the order
    UPDATE "ingredients"
    SET "inventory_count" = "inventory_count" + NEW."quantity"
    WHERE "id" = NEW."ingredient_id";

    -- Update bank_account with net cash
    UPDATE "bank_account"
    SET "net_cash" = "net_cash" - (
        SELECT SUM("oi"."quantity" * "si"."price_per_unit")
        FROM "order_items" AS "oi"
        JOIN "suppliers_ingredients" AS "si" ON "oi"."ingredient_id" = "si"."ingredient_id"
        WHERE "oi"."order_id" = NEW."order_id"
    )
    WHERE "id" = 1;
END;

-- Trigger (Sales) to validate inventory before sale and update relevant records
CREATE TRIGGER IF NOT EXISTS "validate_and_update_inventory_before_sale"
BEFORE INSERT ON "sales_items"
FOR EACH ROW
BEGIN
    -- Check if there is enough inventory for each ingredient in the menu item
    SELECT RAISE(FAIL, 'Not enough inventory for sale')
    WHERE EXISTS (
        SELECT 1
        FROM "dishes_ingredients" AS "di"
        JOIN "ingredients" AS "i" ON "di"."ingredient_id" = "i"."id"
        WHERE "di"."menu_item_id" = NEW."menu_item_id"
        AND "i"."inventory_count" < (NEW."quantity" * "di"."quantity")
    );

    -- Deduct the inventory for each ingredient in the sold item
    UPDATE "ingredients"
    SET "inventory_count" = "inventory_count" - (NEW."quantity" * (
        SELECT "di"."quantity"
        FROM "dishes_ingredients" AS "di"
        WHERE "di"."menu_item_id" = NEW."menu_item_id"
        AND "di"."ingredient_id" = "ingredients"."id"
    ))
    WHERE "id" IN (
        SELECT "di"."ingredient_id"
        FROM "dishes_ingredients" AS "di"
        WHERE "di"."menu_item_id" = NEW."menu_item_id"
    );
END;

--  Trigger (Sales) to update bank_account (cash and VAT) and total_quantity_sold in menu_items after a sale
CREATE TRIGGER IF NOT EXISTS "update_after_sale"
AFTER INSERT ON "sales_items"
BEGIN
    -- Update bank_account: Add 80% of the sale to net cash and 20% to VAT
    UPDATE "bank_account"
    SET "net_cash" = "net_cash" + (
        SELECT SUM(NEW."quantity" * "mi"."price" * 0.80)
        FROM "menu_items" AS "mi"
        WHERE "mi"."id" = NEW."menu_item_id"
    ),
    "vat_due" = "vat_due" + (
        SELECT SUM(NEW."quantity" * "mi"."price" * 0.20)
        FROM "menu_items" AS "mi"
        WHERE "mi"."id" = NEW."menu_item_id"
    )
    WHERE "id" = 1;

    -- Update total_quantity_sold in menu_items
    UPDATE "menu_items"
    SET "total_quantity_sold" = "total_quantity_sold" + NEW."quantity"
    WHERE "id" = NEW."menu_item_id";
END;


-- VIEWS

-- View for Ingredients List Ordered by Category and Name
CREATE VIEW "ingredients_ordered" AS
SELECT
    "name",
    "category",
    "inventory_count",
    "allergens"
FROM
    "ingredients"
ORDER BY
    "category",
    "name";

-- View for orders summary
CREATE VIEW "orders_summary" AS
SELECT
    o."order_date",
    s."name" AS "supplier_name",
    SUM(oi."quantity" * si."price_per_unit") AS "total_order_value"
FROM
    "orders" o
JOIN
    "order_items" oi ON o."id" = oi."order_id"
JOIN
    "ingredients" i ON oi."ingredient_id" = i."id"
JOIN
    "suppliers_ingredients" si ON i."id" = si."ingredient_id" AND o."supplier_id" = si."supplier_id"
JOIN
    "suppliers" s ON o."supplier_id" = s."id"
GROUP BY
    o."id",
    o."order_date",
    s."name";


-- View for items available for sale
CREATE VIEW "menu_items_availability" AS
SELECT
    mi."name",
    MIN(i."inventory_count" / di."quantity") AS "possible_servings"
FROM
    "menu_items" mi
JOIN
    "dishes_ingredients" di ON mi."id" = di."menu_item_id"
JOIN
    "ingredients" i ON di."ingredient_id" = i."id"
GROUP BY
    mi."id", mi."name";

-- Menu profitability
CREATE VIEW "menu_items_profit" AS
SELECT
    mi."name",
    mi."price" AS "selling_price",
    mi."price" * 0.80 AS "price_without_vat",  -- Menu selling price without VAT
    SUM(di."quantity" * si."price_per_unit") AS "cost_of_ingredients",
    (mi."price" * 0.80) - SUM(di."quantity" * si."price_per_unit") AS "net_gross_profit",
    ROUND(((mi."price" * 0.80) - SUM(di."quantity" * si."price_per_unit")) / (mi."price" * 0.80) * 100, 2) AS "net_gross_profit_percentage"
FROM
    "menu_items" mi
JOIN
    "dishes_ingredients" di ON mi."id" = di."menu_item_id"
JOIN
    "suppliers_ingredients" si ON di."ingredient_id" = si."ingredient_id"
GROUP BY
    mi."id", mi."name", mi."price"
ORDER BY
    "net_gross_profit" ASC;


-- View for total sales
CREATE VIEW "total_sales_value" AS
SELECT
    SUM(si."quantity" * mi."price") AS "total_sales_value"
FROM
    "sales_items" si
JOIN
    "menu_items" mi ON si."menu_item_id" = mi."id";

-- View for best selling items
CREATE VIEW "best_selling_food" AS
SELECT
    mi."id",
    mi."name",
    SUM(si."quantity") AS "total_quantity_sold"
FROM
    "sales_items" si
JOIN
    "menu_items" mi ON si."menu_item_id" = mi."id"
GROUP BY
    mi."id", mi."name"
ORDER BY
    "total_quantity_sold" DESC
LIMIT 1;


-- INDEXES

CREATE INDEX IF NOT EXISTS "supplier_name_index" ON "suppliers"("name");
CREATE INDEX IF NOT EXISTS "ingredient_name_index" ON "ingredients"("name");
CREATE INDEX IF NOT EXISTS "mi_name_index" ON "menu_items"("name");

