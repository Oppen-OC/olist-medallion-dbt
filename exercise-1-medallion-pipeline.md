# Exercise 1: Medallion Architecture Data Pipeline

## 🏆 Project Objective
Build and deploy a Medallion Architecture data pipeline using open table formats and structured layers (Bronze, Silver, Gold).

*   **Dataset Selection**: Select any public dataset from Kaggle, UCI, or any other open data source (e.g., e-commerce transactions, sensor logs, weather data).
*   **Bronze Layer**: Ingest the raw data files with minimal modification. Keep the original schema and format.
*   **Silver Layer**: Clean, filter, validate schemas, deduplicate, and enrich the datasets to establish clean, queryable tables.
*   **Gold Layer**: Design aggregated analytical views optimized for business queries and reporting.

---

## ⚙️ Recommended Stacks

### Option 1 (Local/Hybrid)
*   **Stack**: DuckDB + dbt
*   **Details**: Build modular, local SQL pipelines, modeling relationships, and documenting columns directly through dbt schema configs.

### Option 2 (Cloud-Native)
*   **Stack**: Google Cloud BigQuery Sandbox + Dataform (or similar AWS/Azure equivalents)
*   **Details**: Create and orchestrate SQL-based transformations, schema assertions, and tables natively in the cloud.

### Option 3 (Pipeline Reuse)
*   **Stack**: Custom End-to-End Pipeline stack from Module 2, Exercise 2 (e.g., Debezium, Kafka, Spark/Flink, and a database/lakehouse)
*   **Details**: Reuse your own dockerized or cloud-native ingestion/processing architecture to implement the three distinct structural layers.

---

## 📤 Project Deliverables

1.  **Deliverable 1: Schema Definitions**
    *   Descriptions and schema definitions for the Bronze, Silver, and Gold datasets, detailing data types and constraints.
2.  **Deliverable 2: Code Repository**
    *   A clean codebase containing your transformation code (e.g., dbt models, Dataform definitions, SQL scripts, or PySpark notebooks).
3.  **Deliverable 3: Final Validation Queries**
    *   SQL query outputs from your Gold layer illustrating the final business value derived (e.g., monthly sales performance, average sensor readings, user engagement trends).

---
[⬅ Back to Module 3 README](./README.md)
