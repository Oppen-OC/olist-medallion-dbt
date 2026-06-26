# Exercise 1: Multi-Tier Lakehouse Data Pipeline

## 🏆 Project Objective
Build and deploy a multi-tier lakehouse data storage pipeline using open table formats and structured layers (Bronze, Silver, Gold).

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
