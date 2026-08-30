# Final Validation Queries — Gold Layer

Query definitions live in [`analyses/`](analyses/) (dbt `analyses` are compiled but not materialized — run `dbt compile` to resolve `ref()`, or query the tables directly as below). Output captured from `olist.duckdb` after a full `dbt run`.

## 1. Monthly sales trend

Business question: how did revenue and order volume evolve month over month?
Query: [`analyses/monthly_sales_trend.sql`](analyses/monthly_sales_trend.sql)

| order_month | total_orders | total_revenue | avg_order_value |
|---|---|---|---|
| 2016-09-01 | 2 | 279.69 | 139.85 |
| 2016-10-01 | 296 | 53495.01 | 180.73 |
| 2016-12-01 | 1 | 19.62 | 19.62 |
| 2017-01-01 | 787 | 136943.46 | 174.01 |
| 2017-02-01 | 1718 | 283561.69 | 165.05 |
| 2017-03-01 | 2617 | 425617.96 | 162.64 |
| 2017-04-01 | 2377 | 405848.61 | 170.74 |
| 2017-05-01 | 3640 | 582710.83 | 160.09 |
| 2017-06-01 | 3205 | 499652.24 | 155.90 |
| 2017-07-01 | 3946 | 578753.73 | 146.67 |
| 2017-08-01 | 4272 | 661903.52 | 154.94 |
| 2017-09-01 | 4227 | 717102.72 | 169.65 |
| 2017-10-01 | 4547 | 764756.03 | 168.19 |
| 2017-11-01 | 7421 | 1172191.68 | 157.96 |
| 2017-12-01 | 5618 | 861526.77 | 153.35 |
| 2018-01-01 | 7187 | 1101920.01 | 153.32 |
| 2018-02-01 | 6624 | 979486.16 | 147.87 |
| 2018-03-01 | 7168 | 1152656.99 | 160.81 |
| 2018-04-01 | 6919 | 1156248.89 | 167.11 |
| 2018-05-01 | 6833 | 1145686.46 | 167.67 |
| 2018-06-01 | 6145 | 1020381.90 | 166.05 |
| 2018-07-01 | 6233 | 1039783.58 | 166.82 |
| 2018-08-01 | 6421 | 996973.51 | 155.27 |
| 2018-09-01 | 1 | 166.46 | 166.46 |

**Read:** business ramps up from late 2016, peaks Nov 2017 (Black Friday, 7421 orders / $1.17M), then plateaus ~$1M/month through mid-2018. First/last months are partial (dataset edges).

## 2. Top product categories by revenue

Business question: which product categories generate the most revenue?
Query: [`analyses/top_categories.sql`](analyses/top_categories.sql)

| product_category | total_orders | total_items_sold | total_revenue | avg_item_price |
|---|---|---|---|---|
| health_beauty | 8800 | 9634 | 1255695.13 | 130.34 |
| watches_gifts | 5604 | 5970 | 1198185.21 | 200.70 |
| bed_bath_table | 9399 | 11097 | 1035964.06 | 93.36 |
| sports_leisure | 7673 | 8590 | 979740.92 | 114.06 |
| computers_accessories | 6654 | 7781 | 904322.02 | 116.22 |
| furniture_decor | 6425 | 8298 | 727465.05 | 87.67 |
| housewares | 5847 | 6915 | 626825.80 | 90.65 |
| cool_stuff | 3617 | 3780 | 620835.39 | 164.24 |
| auto | 3873 | 4205 | 586620.73 | 139.51 |
| garden_tools | 3505 | 4328 | 481009.94 | 111.14 |

**Read:** `health_beauty` leads on total revenue despite a lower average ticket than `watches_gifts` ($200.70 avg) — volume beats margin here.

## 3. Top sellers by revenue

Business question: which sellers drive the most revenue, and are they well reviewed?
Query: [`analyses/top_sellers.sql`](analyses/top_sellers.sql)

| seller_id | seller_city | seller_state | total_orders | total_revenue | avg_review_score |
|---|---|---|---|---|---|
| 4869f7a5dfa277a7dca6462dcf3b52b2 | guariba | SP | 1131 | 229237.63 | 4.12 |
| 53243585a1d6dc2643021fd1853d8905 | lauro de freitas | BA | 358 | 222776.05 | 4.08 |
| 4a3ca9315b744ce9f8e9374361493884 | ibitinga | SP | 1804 | 200326.12 | 3.81 |
| fa1c13f2614d7b5c4749cbc52fecda94 | sumare | SP | 584 | 192842.13 | 4.34 |
| 7c67e1448b00f6e969d365cea6b010ab | itaquaquecetuba | SP | 982 | 187923.89 | 3.35 |
| 7e93a43ef30c4f03f38b393420bc753a | barueri | SP | 332 | 172583.88 | 4.21 |
| da8622b14eb17ae2831f4ac5b9dab84a | piracicaba | SP | 1314 | 160236.57 | 4.07 |
| 7a67c85e85bb2ce8582c35f2203ad736 | sao paulo | SP | 1159 | 141715.54 | 4.23 |
| 1025f0e2d44d7041d6cf58b6550e0bfa | sao paulo | SP | 915 | 138968.55 | 3.87 |
| 955fee9216a65b617aa5c0531780ce60 | sao paulo | SP | 1286 | 135159.7 | 4.05 |

**Read:** top revenue sellers cluster in SP state (logistics hub effect). Revenue rank and volume rank diverge: the highest-volume seller (`4a3ca9315b...`, 1804 orders) ranks only third on revenue, and the two weakest review scores in the top 10 — `7c67e1448b...` (3.35) and `4a3ca9315b...` (3.81) — both belong to high-volume sellers, worth flagging for a quality review.

## How to reproduce

```bash
dbt run
dbt compile --select monthly_sales_trend top_categories top_sellers
# then run the compiled SQL in target/compiled/olist_medallion/analyses/ against olist.duckdb
```
