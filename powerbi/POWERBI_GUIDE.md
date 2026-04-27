# Dashboard Power BI — Superstore Analytics

## Arquivo de trabalho

O arquivo `Superstore_Dashboard.pbix` está disponível na pasta `/powerbi/` deste repositório.

> **Nota:** Para abrir o `.pbix` você precisa do [Power BI Desktop](https://powerbi.microsoft.com/pt-br/desktop/).

---

## Como conectar ao PostgreSQL

1. Abra o Power BI Desktop
2. Clique em **Obter Dados → PostgreSQL**
3. Preencha:
   - **Servidor:** `localhost`
   - **Banco de dados:** `superstore_db`
4. Selecione a tabela `sales.orders`
5. Clique em **Carregar**

---

## Estrutura do Dashboard (3 páginas)

### Página 1 — Visão Geral Executiva
| Visual | Tipo | Campo(s) |
|---|---|---|
| Receita Total | Cartão | SUM(sales) |
| Pedidos Totais | Cartão | DISTINCTCOUNT(order_id) |
| Ticket Médio | Cartão | AVERAGE(sales) |
| Receita por Ano | Gráfico de Barras | order_year × SUM(sales) |
| Receita por Trimestre | Gráfico de Linhas | order_quarter × SUM(sales) |
| % por Segmento | Gráfico de Rosca | segment × SUM(sales) |

### Página 2 — Produtos & Categorias
| Visual | Tipo | Campo(s) |
|---|---|---|
| Top 10 Produtos | Gráfico de Barras Horizontais | product_name × SUM(sales) |
| Receita por Categoria | Treemap | category × sub_category × SUM(sales) |
| Tabela Detalhada | Tabela | category, sub_category, pedidos, receita |
| Filtro de Categoria | Segmentação | category |

### Página 3 — Clientes & Regiões
| Visual | Tipo | Campo(s) |
|---|---|---|
| Mapa de Receita por Estado | Mapa Preenchido | state × SUM(sales) |
| Receita por Região | Gráfico de Barras | region × SUM(sales) |
| Top 10 Clientes | Tabela | customer_name, pedidos, receita |
| Média de Dias de Envio | Cartão | AVERAGE(days_to_ship) |
| Modal de Envio | Gráfico de Pizza | ship_mode × COUNT(row_id) |

---

## Medidas DAX criadas

```dax
-- Receita Total
Receita Total = SUM(orders[sales])

-- Número de Pedidos
Total Pedidos = DISTINCTCOUNT(orders[order_id])

-- Ticket Médio por Pedido
Ticket Medio = 
    DIVIDE(
        [Receita Total],
        [Total Pedidos]
    )

-- Crescimento YoY
Crescimento YoY = 
    VAR receitaAtual  = [Receita Total]
    VAR receitaAntiga = CALCULATE(
        [Receita Total],
        DATEADD(orders[order_date], -1, YEAR)
    )
    RETURN DIVIDE(receitaAtual - receitaAntiga, receitaAntiga)

-- % do Total (para segmento)
Pct do Total = 
    DIVIDE(
        [Receita Total],
        CALCULATE([Receita Total], ALL(orders[segment]))
    )

-- Média dias de envio
Media Dias Envio = AVERAGE(orders[days_to_ship])
```

---

## Filtros Globais (Slicers)

Adicione estes filtros em todas as páginas para interatividade:

- `order_year` — Seleção de ano
- `region` — Seleção de região  
- `segment` — Segmento de cliente
- `category` — Categoria de produto

---

## Paleta de Cores sugerida

| Elemento | Cor Hex |
|---|---|
| Cor primária | `#2E86AB` |
| Cor secundária | `#A23B72` |
| Destaque | `#F18F01` |
| Fundo | `#F5F5F5` |
| Texto | `#333333` |

