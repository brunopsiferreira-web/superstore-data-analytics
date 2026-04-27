-- ─────────────────────────────────────────────────────
-- 1. VISÃO GERAL DO NEGÓCIO
-- ─────────────────────────────────────────────────────
SELECT
    COUNT(DISTINCT order_id)            AS total_pedidos,
    COUNT(*)                            AS total_itens,
    COUNT(DISTINCT customer_id)         AS clientes_unicos,
    COUNT(DISTINCT product_id)          AS produtos_unicos,
    ROUND(SUM(sales)::NUMERIC, 2)       AS receita_total,
    ROUND(AVG(sales)::NUMERIC, 2)       AS ticket_medio_item,
    MIN(order_date)                     AS primeiro_pedido,
    MAX(order_date)                     AS ultimo_pedido
FROM sales.orders;


-- ─────────────────────────────────────────────────────
-- 2. RECEITA POR ANO — CRESCIMENTO YoY
-- ─────────────────────────────────────────────────────
WITH receita_ano AS (
    SELECT
        order_year,
        ROUND(SUM(sales)::NUMERIC, 2) AS receita
    FROM sales.orders
    GROUP BY order_year
),
crescimento AS (
    SELECT
        order_year,
        receita,
        LAG(receita) OVER (ORDER BY order_year) AS receita_ano_anterior,
        ROUND(
            (receita - LAG(receita) OVER (ORDER BY order_year))
            / NULLIF(LAG(receita) OVER (ORDER BY order_year), 0) * 100
        , 1) AS crescimento_pct
    FROM receita_ano
)
SELECT
    order_year                               AS ano,
    receita,
    COALESCE(receita_ano_anterior, 0)        AS receita_ano_anterior,
    COALESCE(crescimento_pct::TEXT || '%', '—') AS crescimento_yoy
FROM crescimento
ORDER BY order_year;


-- ─────────────────────────────────────────────────────
-- 3. RECEITA POR REGIÃO E CATEGORIA
-- ─────────────────────────────────────────────────────
SELECT
    region                                  AS regiao,
    category                                AS categoria,
    COUNT(*)                                AS qtd_pedidos,
    ROUND(SUM(sales)::NUMERIC, 2)           AS receita_total,
    ROUND(AVG(sales)::NUMERIC, 2)           AS ticket_medio,
    ROUND(
        SUM(sales) * 100.0 / SUM(SUM(sales)) OVER (PARTITION BY region)
    , 1)                                    AS pct_da_regiao
FROM sales.orders
GROUP BY region, category
ORDER BY region, receita_total DESC;


-- ─────────────────────────────────────────────────────
-- 4. TOP 10 PRODUTOS POR RECEITA
-- ─────────────────────────────────────────────────────
SELECT
    product_id,
    product_name,
    category,
    sub_category,
    COUNT(*)                            AS vezes_vendido,
    ROUND(SUM(sales)::NUMERIC, 2)       AS receita_total,
    ROUND(AVG(sales)::NUMERIC, 2)       AS preco_medio
FROM sales.orders
GROUP BY product_id, product_name, category, sub_category
ORDER BY receita_total DESC
LIMIT 10;


-- ─────────────────────────────────────────────────────
-- 5. TOP 10 CLIENTES POR RECEITA
-- ─────────────────────────────────────────────────────
SELECT
    customer_id,
    customer_name,
    segment,
    COUNT(DISTINCT order_id)                AS total_pedidos,
    ROUND(SUM(sales)::NUMERIC, 2)           AS receita_total,
    ROUND(AVG(sales)::NUMERIC, 2)           AS ticket_medio,
    MIN(order_date)                         AS primeiro_pedido,
    MAX(order_date)                         AS ultimo_pedido
FROM sales.orders
GROUP BY customer_id, customer_name, segment
ORDER BY receita_total DESC
LIMIT 10;


-- ─────────────────────────────────────────────────────
-- 6. ANÁLISE DE SAZONALIDADE — RECEITA POR MÊS
-- ─────────────────────────────────────────────────────
SELECT
    order_year                              AS ano,
    order_month                             AS mes,
    TO_CHAR(DATE_TRUNC('month',
        MAKE_DATE(order_year, order_month, 1)), 'Mon') AS nome_mes,
    COUNT(*)                                AS qtd_pedidos,
    ROUND(SUM(sales)::NUMERIC, 2)           AS receita
FROM sales.orders
GROUP BY order_year, order_month
ORDER BY order_year, order_month;


-- ─────────────────────────────────────────────────────
-- 7. PERFORMANCE POR SEGMENTO DE CLIENTE
-- ─────────────────────────────────────────────────────
SELECT
    segment,
    COUNT(DISTINCT customer_id)             AS clientes,
    COUNT(DISTINCT order_id)                AS pedidos,
    ROUND(SUM(sales)::NUMERIC, 2)           AS receita_total,
    ROUND(AVG(sales)::NUMERIC, 2)           AS ticket_medio,
    ROUND(
        SUM(sales) * 100.0 / SUM(SUM(sales)) OVER ()
    , 1)                                    AS pct_receita_total
FROM sales.orders
GROUP BY segment
ORDER BY receita_total DESC;


-- ─────────────────────────────────────────────────────
-- 8. ANÁLISE DE FRETE — MODAL MAIS USADO POR SEGMENTO
-- ─────────────────────────────────────────────────────
SELECT
    segment,
    ship_mode,
    COUNT(*)                                AS qtd_pedidos,
    ROUND(AVG(days_to_ship), 1)             AS media_dias_envio,
    ROUND(SUM(sales)::NUMERIC, 2)           AS receita_total,
    RANK() OVER (
        PARTITION BY segment
        ORDER BY COUNT(*) DESC
    )                                       AS ranking_modal
FROM sales.orders
GROUP BY segment, ship_mode
ORDER BY segment, ranking_modal;


-- ─────────────────────────────────────────────────────
-- 9. SUB-CATEGORIAS COM MELHOR DESEMPENHO (TOP 5)
-- ─────────────────────────────────────────────────────
WITH sub_cat_perf AS (
    SELECT
        category,
        sub_category,
        ROUND(SUM(sales)::NUMERIC, 2)       AS receita,
        COUNT(*)                            AS pedidos,
        ROUND(AVG(days_to_ship), 1)         AS media_envio,
        DENSE_RANK() OVER (
            PARTITION BY category
            ORDER BY SUM(sales) DESC
        )                                   AS rank_na_categoria
    FROM sales.orders
    GROUP BY category, sub_category
)
SELECT *
FROM sub_cat_perf
WHERE rank_na_categoria <= 5
ORDER BY category, rank_na_categoria;


-- ─────────────────────────────────────────────────────
-- 10. ESTADOS COM MAIOR RECEITA — RANKING NACIONAL
-- ─────────────────────────────────────────────────────
SELECT
    state                                   AS estado,
    region                                  AS regiao,
    COUNT(DISTINCT customer_id)             AS clientes,
    COUNT(*)                                AS pedidos,
    ROUND(SUM(sales)::NUMERIC, 2)           AS receita_total,
    RANK() OVER (ORDER BY SUM(sales) DESC)  AS ranking
FROM sales.orders
GROUP BY state, region
ORDER BY receita_total DESC
LIMIT 15;
