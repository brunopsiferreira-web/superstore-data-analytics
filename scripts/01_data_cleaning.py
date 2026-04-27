import pandas as pd
import os

# ─────────────────────────────────────────
# 1. CARREGAMENTO
# ─────────────────────────────────────────
RAW_PATH      = "data/raw/superstore.csv"
PROCESSED_PATH = "data/processed/superstore_clean.csv"

df = pd.read_csv(RAW_PATH)

print("=" * 50)
print("ANÁLISE INICIAL DO DATASET")
print("=" * 50)
print(f"Linhas: {df.shape[0]:,} | Colunas: {df.shape[1]}")
print()
print("Tipos de dados:")
print(df.dtypes)
print()
print("Valores nulos por coluna:")
print(df.isnull().sum())
print()

# ─────────────────────────────────────────
# 2. RENOMEAR COLUNAS (snake_case, sem espaço)
# ─────────────────────────────────────────
df.columns = (
    df.columns
    .str.strip()
    .str.lower()
    .str.replace(" ", "_")
    .str.replace("-", "_")
)

print("Colunas renomeadas:", df.columns.tolist())

# ─────────────────────────────────────────
# 3. DATAS
# ─────────────────────────────────────────
df["order_date"] = pd.to_datetime(df["order_date"], dayfirst=True, format="mixed")
df["ship_date"]  = pd.to_datetime(df["ship_date"],  dayfirst=True, format="mixed")

# Criar coluna de dias para envio
df["days_to_ship"] = (df["ship_date"] - df["order_date"]).dt.days

# Extrair ano e mês do pedido
df["order_year"]  = df["order_date"].dt.year
df["order_month"] = df["order_date"].dt.month
df["order_quarter"] = df["order_date"].dt.quarter

# ─────────────────────────────────────────
# 4. VALORES NULOS
# ─────────────────────────────────────────
df["postal_code"] = df["postal_code"].fillna(0).astype(int).astype(str)

# ─────────────────────────────────────────
# 5. REMOVER DUPLICATAS
# ─────────────────────────────────────────
before = len(df)
df = df.drop_duplicates()
after  = len(df)
print(f"\nDuplicatas removidas: {before - after}")

# ─────────────────────────────────────────
# 6. VALIDAÇÕES
# ─────────────────────────────────────────
assert df["sales"].min() > 0, "Existem vendas negativas ou zeradas!"
assert (df["days_to_ship"] >= 0).all(), "Existem datas de envio antes do pedido!"

print("\nValidações OK ✓")

# ─────────────────────────────────────────
# 7. SALVAR CSV LIMPO
# ─────────────────────────────────────────
os.makedirs("data/processed", exist_ok=True)
df.to_csv(PROCESSED_PATH, index=False)

print(f"\nArquivo limpo salvo em: {PROCESSED_PATH}")
print(f"Shape final: {df.shape}")
print()
print("Prévia das colunas finais:")
print(df.head(3).to_string())
