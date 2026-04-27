# Dicionário de Dados — Superstore

## Tabela: `sales.orders`

| Coluna | Tipo SQL | Origem | Descrição |
|---|---|---|---|
| `row_id` | INTEGER | Original | Identificador único da linha — chave primária |
| `order_id` | VARCHAR(20) | Original | ID do pedido (vários itens podem ter o mesmo order_id) |
| `order_date` | DATE | Original | Data em que o pedido foi realizado |
| `ship_date` | DATE | Original | Data em que o pedido foi enviado |
| `ship_mode` | VARCHAR(20) | Original | Modal de entrega escolhido pelo cliente |
| `customer_id` | VARCHAR(15) | Original | Identificador único do cliente |
| `customer_name` | VARCHAR(100) | Original | Nome completo do cliente |
| `segment` | VARCHAR(20) | Original | Segmento de mercado do cliente |
| `country` | VARCHAR(50) | Original | País do pedido (todos EUA neste dataset) |
| `city` | VARCHAR(100) | Original | Cidade de entrega |
| `state` | VARCHAR(100) | Original | Estado de entrega |
| `postal_code` | VARCHAR(10) | Original | CEP de entrega (11 nulos tratados como "0") |
| `region` | VARCHAR(20) | Original | Região geográfica dos EUA |
| `product_id` | VARCHAR(20) | Original | Identificador único do produto |
| `category` | VARCHAR(30) | Original | Categoria principal do produto |
| `sub_category` | VARCHAR(30) | Original | Sub-categoria do produto |
| `product_name` | VARCHAR(300) | Original | Nome completo do produto |
| `sales` | NUMERIC(12,4) | Original | Valor da venda em USD |
| `days_to_ship` | INTEGER | **Derivado** | Diferença em dias entre ship_date e order_date |
| `order_year` | SMALLINT | **Derivado** | Ano extraído de order_date |
| `order_month` | SMALLINT | **Derivado** | Mês extraído de order_date (1–12) |
| `order_quarter` | SMALLINT | **Derivado** | Trimestre extraído de order_date (1–4) |

---

## Valores categóricos

### `segment`
| Valor | Descrição |
|---|---|
| Consumer | Cliente pessoa física |
| Corporate | Empresas |
| Home Office | Profissionais autônomos / home office |

### `ship_mode`
| Valor | Descrição Estimada |
|---|---|
| Same Day | Entrega no mesmo dia |
| First Class | Entrega prioritária (1–2 dias) |
| Second Class | Entrega standard rápida (3–4 dias) |
| Standard Class | Entrega econômica (5–7 dias) |

### `region`
| Valor | Estados |
|---|---|
| West | CA, OR, WA, NV, AZ, UT, CO, ID, MT, WY, NM, AK, HI |
| East | NY, PA, NJ, CT, MA, RI, VT, NH, ME, VA, NC, SC, GA, FL, DE, MD, DC |
| Central | IL, OH, MI, IN, WI, MN, MO, IA, KS, NE, ND, SD, OK, TX, AR, LA, MS |
| South | KY, TN, AL, WV |

### `category`
| Valor | Sub-categorias |
|---|---|
| Furniture | Bookcases, Chairs, Furnishings, Tables |
| Office Supplies | Appliances, Art, Binders, Envelopes, Fasteners, Labels, Paper, Storage, Supplies |
| Technology | Accessories, Copiers, Machines, Phones |

---

## Regras de Qualidade

- `sales` deve ser sempre > 0 (constraint no banco)
- `days_to_ship` deve ser >= 0 (constraint no banco)
- `postal_code` nulos foram substituídos por `"0"` na limpeza
- Nenhuma duplicata identificada no dataset original
- Datas convertidas para formato DATE no PostgreSQL (era string no CSV)
