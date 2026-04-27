-- 1. CRIAR O BANCO (execute conectado ao banco 'postgres')
-- CREATE DATABASE superstore_db;

-- 2. CRIAR SCHEMA
CREATE SCHEMA IF NOT EXISTS sales;

-- 3. CRIAR TABELA PRINCIPAL
DROP TABLE IF EXISTS sales.orders;

CREATE TABLE sales.orders (
    row_id        INTEGER       PRIMARY KEY,
    order_id      VARCHAR(20)   NOT NULL,
    order_date    DATE          NOT NULL,
    ship_date     DATE          NOT NULL,
    ship_mode     VARCHAR(20)   NOT NULL,
    customer_id   VARCHAR(15)   NOT NULL,
    customer_name VARCHAR(100)  NOT NULL,
    segment       VARCHAR(20)   NOT NULL,
    country       VARCHAR(50)   NOT NULL,
    city          VARCHAR(100)  NOT NULL,
    state         VARCHAR(100)  NOT NULL,
    postal_code   VARCHAR(10),
    region        VARCHAR(20)   NOT NULL,
    product_id    VARCHAR(20)   NOT NULL,
    category      VARCHAR(30)   NOT NULL,
    sub_category  VARCHAR(30)   NOT NULL,
    product_name  VARCHAR(300)  NOT NULL,
    sales         NUMERIC(12,4) NOT NULL CHECK (sales > 0),
    days_to_ship  INTEGER       NOT NULL CHECK (days_to_ship >= 0),
    order_year    SMALLINT      NOT NULL,
    order_month   SMALLINT      NOT NULL,
    order_quarter SMALLINT      NOT NULL
);

-- 4. IMPORTAR CSV (ajuste o caminho conforme seu ambiente)
-- Opção A — via psql (recomendado)
-- \copy sales.orders FROM 'data/processed/superstore_clean.csv' CSV HEADER;

-- Opção B — via script Python (scripts/02_import_to_postgres.py)

-- 5. ÍNDICES PARA PERFORMANCE
CREATE INDEX idx_orders_order_date   ON sales.orders (order_date);
CREATE INDEX idx_orders_customer_id  ON sales.orders (customer_id);
CREATE INDEX idx_orders_category     ON sales.orders (category);
CREATE INDEX idx_orders_region       ON sales.orders (region);
CREATE INDEX idx_orders_segment      ON sales.orders (segment);
CREATE INDEX idx_orders_order_year   ON sales.orders (order_year);

-- 6. COMENTÁRIOS
COMMENT ON TABLE sales.orders IS 'Pedidos do Superstore — dados de vendas de varejo nos EUA';
COMMENT ON COLUMN sales.orders.days_to_ship IS 'Diferença em dias entre order_date e ship_date';
COMMENT ON COLUMN sales.orders.order_quarter IS 'Trimestre do pedido (1–4)';

-- 7. VERIFICAÇÃO
SELECT
    COUNT(*)                           AS total_registros,
    MIN(order_date)                    AS data_minima,
    MAX(order_date)                    AS data_maxima,
    ROUND(SUM(sales)::NUMERIC, 2)      AS receita_total,
    COUNT(DISTINCT customer_id)        AS clientes_unicos,
    COUNT(DISTINCT product_id)         AS produtos_unicos
FROM sales.orders;
