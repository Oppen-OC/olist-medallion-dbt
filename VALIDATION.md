# Final Validation Queries — Gold Layer

Query definitions live in [`analyses/`](analyses/) (dbt `analyses` are compiled but not materialized — run `dbt compile` to resolve `ref()`, or query the tables directly as below). Output captured from `olist.duckdb` after a full `dbt build`. `total_revenue` is merchandise revenue (`sum(price)`, freight excluded) in every table.

## 1. Monthly sales trend

Business question: how did revenue and order volume evolve month over month?
Query: [`analyses/monthly_sales_trend.sql`](analyses/monthly_sales_trend.sql)

| order_month | total_orders | total_revenue | avg_order_value |
|---|---|---|---|
| 2016-09-01 | 2 | 207.86 | 103.93 |
| 2016-10-01 | 296 | 46514.99 | 157.15 |
| 2016-12-01 | 1 | 10.90 | 10.90 |
| 2017-01-01 | 787 | 120098.27 | 152.60 |
| 2017-02-01 | 1718 | 244959.35 | 142.58 |
| 2017-03-01 | 2617 | 368341.32 | 140.75 |
| 2017-04-01 | 2377 | 353842.98 | 148.86 |
| 2017-05-01 | 3640 | 503159.19 | 138.23 |
| 2017-06-01 | 3205 | 429916.61 | 134.14 |
| 2017-07-01 | 3946 | 492287.30 | 124.76 |
| 2017-08-01 | 4272 | 568245.79 | 133.02 |
| 2017-09-01 | 4227 | 621415.91 | 147.01 |
| 2017-10-01 | 4547 | 660179.62 | 145.19 |
| 2017-11-01 | 7421 | 1003862.14 | 135.27 |
| 2017-12-01 | 5618 | 742183.79 | 132.11 |
| 2018-01-01 | 7187 | 945456.29 | 131.55 |
| 2018-02-01 | 6624 | 837895.43 | 126.49 |
| 2018-03-01 | 7168 | 981051.06 | 136.87 |
| 2018-04-01 | 6919 | 993592.98 | 143.60 |
| 2018-05-01 | 6833 | 992871.75 | 145.31 |
| 2018-06-01 | 6145 | 863265.53 | 140.48 |
| 2018-07-01 | 6233 | 878044.27 | 140.87 |
| 2018-08-01 | 6421 | 848860.10 | 132.20 |
| 2018-09-01 | 1 | 145.00 | 145.00 |

**Read:** business ramps up from late 2016, peaks Nov 2017 (Black Friday, 7421 orders / $1.00M), dips to $0.74M in Dec 2017, then holds at $0.84M-$0.99M/month from Jan to Aug 2018. First/last months are partial (dataset edges).

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

**Read:** `health_beauty` leads on total revenue despite a lower average item price than `watches_gifts` ($200.70 avg) — volume beats price point here.

## 3. Top sellers by revenue

Business question: which sellers drive the most revenue, and are they well reviewed?
Query: [`analyses/top_sellers.sql`](analyses/top_sellers.sql)

| seller_id | seller_city | seller_state | total_orders | total_revenue | avg_review_score |
|---|---|---|---|---|---|
| 4869f7a5dfa277a7dca6462dcf3b52b2 | guariba | SP | 1131 | 229237.63 | 4.13 |
| 53243585a1d6dc2643021fd1853d8905 | lauro de freitas | BA | 358 | 222776.05 | 4.13 |
| 4a3ca9315b744ce9f8e9374361493884 | ibitinga | SP | 1804 | 200326.12 | 3.83 |
| fa1c13f2614d7b5c4749cbc52fecda94 | sumare | SP | 584 | 192842.13 | 4.34 |
| 7c67e1448b00f6e969d365cea6b010ab | itaquaquecetuba | SP | 982 | 187923.89 | 3.49 |
| 7e93a43ef30c4f03f38b393420bc753a | barueri | SP | 332 | 172583.88 | 4.25 |
| da8622b14eb17ae2831f4ac5b9dab84a | piracicaba | SP | 1314 | 160236.57 | 4.18 |
| 7a67c85e85bb2ce8582c35f2203ad736 | sao paulo | SP | 1159 | 141715.54 | 4.24 |
| 1025f0e2d44d7041d6cf58b6550e0bfa | sao paulo | SP | 915 | 138968.55 | 4.00 |
| 955fee9216a65b617aa5c0531780ce60 | sao paulo | SP | 1286 | 135159.70 | 4.16 |

**Read:** 9 of the top 10 revenue sellers are in SP state, against a base rate of 59.7% of all sellers (`silver_sellers`) and 64.4% of total seller revenue (`gold_seller_performance`), so SP is over-represented but not overwhelmingly. Revenue rank and volume rank diverge: the highest-volume seller in the top 10 (`4a3ca9315b...`, 1804 orders) ranks only third on revenue, and the two weakest review scores in the top 10 belong to `7c67e1448b...` (3.49) and `4a3ca9315b...` (3.83), the highest-volume seller in the top 10, worth flagging for a quality review. Review scores cover non-canceled orders only, with each order counted once per seller.

## How to reproduce

```bash
dbt build
dbt compile --select resource_type:analysis
# then run the compiled SQL in target/compiled/olist_medallion/analyses/ against olist.duckdb
```
