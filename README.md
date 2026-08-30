# Module 3: Data-Centric Architectures

This module covers design principles and patterns for building systems around data assets, including decoupled storage and compute, data lakes, data lakehouses, and data mesh architectures.

## Exercises

*   [**Exercise 1: Medallion Architecture Data Pipeline**](./exercise-1-medallion-pipeline.md)
    *   Design and build a Medallion Architecture data pipeline (Bronze/Silver/Gold) on a public dataset using tools like DuckDB+dbt, BigQuery+Dataform, or reusing your Module 2 pipeline stack.
    *   Solution: [`olist_medallion/`](./olist_medallion/README.md) — DuckDB + dbt over the Olist Brazilian E-Commerce dataset. Schemas: [SCHEMA.md](./olist_medallion/SCHEMA.md). Validation queries: [VALIDATION.md](./olist_medallion/VALIDATION.md).

---
[⬅ Back to Home](../README.md)
