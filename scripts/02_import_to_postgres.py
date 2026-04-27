import os
import pandas as pd
import psycopg2
from psycopg2.extras import execute_values
from dotenv import load_dotenv

load_dotenv()
# ─────────────────────────────────────────
# CONFIGURAÇÃO — edite aqui ou use .env
# ─────────────────────────────────────────
DB_CONFIG = {
    "host":     os.getenv("DB_HOST"),
    "port":     int(os.getenv("DB_PORT")),
    "dbname":   os.getenv("DB_NAME"),
    "user":     os.getenv("DB_USER"),
    "password": os.getenv("DB_PASSWORD"),
}

PROCESSED_CSV = "data/processed/superstore_clean.csv"

# ─────────────────────────────────────────
# 1. LER CSV LIMPO
# ─────────────────────────────────────────
print("Lendo CSV limpo...")
df = pd.read_csv(PROCESSED_CSV)

# Garantir tipos corretos para o insert
df["order_date"] = pd.to_datetime(df["order_date"]).dt.date
df["ship_date"]  = pd.to_datetime(df["ship_date"]).dt.date

print(f"  {len(df):,} registros carregados")

# ─────────────────────────────────────────
# 2. CONECTAR AO BANCO
# ─────────────────────────────────────────
print("Conectando ao PostgreSQL...")
conn = psycopg2.connect(**DB_CONFIG)
cur  = conn.cursor()
print("  Conexão OK ✓")

# ─────────────────────────────────────────
# 3. TRUNCATE (evitar duplicatas em re-imports)
# ─────────────────────────────────────────
cur.execute("TRUNCATE TABLE sales.orders RESTART IDENTITY;")
print("  Tabela limpa ✓")

# ─────────────────────────────────────────
# 4. INSERT EM LOTES (batch insert)
# ─────────────────────────────────────────
COLUMNS = [
    "row_id", "order_id", "order_date", "ship_date", "ship_mode",
    "customer_id", "customer_name", "segment", "country", "city",
    "state", "postal_code", "region", "product_id", "category",
    "sub_category", "product_name", "sales",
    "days_to_ship", "order_year", "order_month", "order_quarter",
]

records = [tuple(row) for row in df[COLUMNS].itertuples(index=False)]

INSERT_QUERY = f"""
    INSERT INTO sales.orders ({', '.join(COLUMNS)})
    VALUES %s
    ON CONFLICT (row_id) DO NOTHING;
"""

print(f"Inserindo {len(records):,} registros...")
execute_values(cur, INSERT_QUERY, records, page_size=500)
conn.commit()
print("  Inserção concluída ✓")

# ─────────────────────────────────────────
# 5. VERIFICAÇÃO
# ─────────────────────────────────────────
cur.execute("SELECT COUNT(*) FROM sales.orders;")
count = cur.fetchone()[0]
print(f"  Total na tabela: {count:,} registros ✓")

cur.close()
conn.close()
print("\nImportação finalizada com sucesso!")
