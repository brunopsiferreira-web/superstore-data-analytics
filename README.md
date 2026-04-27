# 📊 Superstore Sales Analytics

> Pipeline completo de dados — do CSV bruto ao dashboard interativo no Power BI.

![Python](https://img.shields.io/badge/Python-3.11+-3776AB?style=flat&logo=python&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-14+-336791?style=flat&logo=postgresql&logoColor=white)
![Power BI](https://img.shields.io/badge/Power%20BI-Dashboard-F2C811?style=flat&logo=powerbi&logoColor=black)
![License](https://img.shields.io/badge/License-MIT-green?style=flat)

---

## 📌 Sobre o Projeto

Este projeto aplica um fluxo real de **engenharia e análise de dados** sobre o dataset clássico **Superstore** — um e-commerce americano com dados de pedidos, clientes e produtos.

O objetivo é demonstrar todas as etapas de um projeto de dados do mundo real:

```
CSV bruto → Limpeza (Python) → PostgreSQL → Análises (SQL) → Dashboard (Power BI)
```

---

## 🗂️ Estrutura do Repositório

```
superstore-data-project/
│
├── data/
│   ├── raw/                    # CSV original (não modificado)
│   │   └── superstore.csv
│   └── processed/              # CSV após limpeza e enriquecimento
│       └── superstore_clean.csv
│
├── scripts/
│   ├── 01_data_cleaning.py     # Limpeza, tipagem e enriquecimento
│   └── 02_import_to_postgres.py# Carga do CSV para o PostgreSQL
│
├── sql/
│   ├── 01_create_database.sql  # DDL: criação do banco e tabela
│   └── 02_analytics_queries.sql# 10 análises completas em SQL
│
├── powerbi/
│   ├── Superstore_Dashboard.pbix  # Arquivo do Power BI Desktop
│   └── POWERBI_GUIDE.md           # Guia de medidas DAX e visuais
│
├── docs/
│   └── data_dictionary.md      # Dicionário de dados
│
├── .gitignore
├── requirements.txt
└── README.md
```

---

## 📂 Sobre o Dataset

**Fonte:** [Kaggle — Superstore Dataset](https://www.kaggle.com/datasets/vivek468/superstore-dataset-final)

| Campo | Descrição |
|---|---|
| `order_id` | Identificador único do pedido |
| `order_date` | Data do pedido |
| `ship_date` | Data de envio |
| `ship_mode` | Modal de entrega (Standard, First Class...) |
| `customer_id` | ID do cliente |
| `segment` | Segmento (Consumer, Corporate, Home Office) |
| `region` | Região dos EUA (West, East, Central, South) |
| `category` | Categoria do produto |
| `sub_category` | Sub-categoria |
| `sales` | Valor da venda em USD |
| `days_to_ship` | *(derivado)* Dias entre pedido e envio |
| `order_year/month/quarter` | *(derivado)* Campos de tempo extraídos |

**Volume:** 9.800 registros | 22 colunas (18 originais + 4 derivadas)

---

## 🛠️ Tecnologias

| Camada | Tecnologia |
|---|---|
| Linguagem | Python 3.11+ |
| Tratamento de dados | pandas |
| Banco de dados | PostgreSQL 14+ |
| Driver de conexão | psycopg2 |
| Análise | SQL puro (window functions, CTEs) |
| Visualização | Power BI Desktop |
| Versionamento | Git + GitHub |

---

## 🚀 Como Executar

### Pré-requisitos

```bash
# Python
pip install -r requirements.txt

# PostgreSQL rodando localmente (porta 5432)
```

### Passo a passo

**1. Clone o repositório**
```bash
git clone https://github.com/seu-usuario/superstore-data-project.git
cd superstore-data-project
```

**2. Limpe e trate os dados**
```bash
python scripts/01_data_cleaning.py
```

**3. Crie o banco no PostgreSQL**
```sql
-- No psql ou DBeaver:
CREATE DATABASE superstore_db;
\c superstore_db
\i sql/01_create_database.sql
```

**4. Importe o CSV para o banco**
```bash
# Configure suas credenciais no .env ou no script
python scripts/02_import_to_postgres.py
```

**5. Execute as análises SQL**
```sql
-- Abra o arquivo no DBeaver, DataGrip ou psql
\i sql/02_analytics_queries.sql
```

**6. Abra o Dashboard no Power BI**
- Instale o [Power BI Desktop](https://powerbi.microsoft.com/pt-br/desktop/)
- Abra `powerbi/Superstore_Dashboard.pbix`
- Atualize a conexão com suas credenciais do PostgreSQL
- Veja o guia em `powerbi/POWERBI_GUIDE.md`

---

## 📊 Análises SQL Incluídas

| # | Análise |
|---|---|
| 1 | Visão geral do negócio (KPIs gerais) |
| 2 | Receita por ano com crescimento YoY |
| 3 | Receita por região e categoria |
| 4 | Top 10 produtos por receita |
| 5 | Top 10 clientes por receita |
| 6 | Sazonalidade — receita por mês |
| 7 | Performance por segmento de cliente |
| 8 | Análise de frete por modal e segmento |
| 9 | Sub-categorias com melhor desempenho |
| 10 | Ranking de estados por receita |

---

## 📈 Principais Insights

- **Technology** é a categoria mais lucrativa, seguida de **Furniture**
- A região **West** lidera em receita total
- O segmento **Consumer** representa ~50% da receita
- Pedidos com **Standard Class** representam mais de 60% dos envios
- Os meses de **novembro e dezembro** têm os maiores picos de vendas

---

## 🗒️ Dicionário de Dados

Veja o arquivo [`docs/data_dictionary.md`](docs/data_dictionary.md) para descrição completa de cada coluna, tipos, regras de negócio e transformações aplicadas.

---

## 📜 Licença

Distribuído sob a licença MIT. Veja `LICENSE` para mais detalhes.

---

## 🙋 Autor

Feito para estudo de Data Analytics.
