# Quick Commerce Operations Analytics & AI Agent

An end-to-end analytics project exploring quick-commerce delivery performance using SQL, Python, SQL Server, Retrieval-Augmented Generation (RAG), and a basic AI agent.

## Project Overview

This project analyzes synthetic quick-commerce order data to investigate delivery reliability and operational performance. It combines SQL-based business analysis with Python-based data access and a documentation-aware AI agent.

The goal is to demonstrate practical skills in data analytics, database querying, operational problem-solving, and introductory AI application development.

**Note:** This project uses synthetic data for demonstration and learning. It does not use real Blinkit or other company data.

## Tech Stack

- **SQL:** SQL Server, T-SQL, analytical queries
- **Python:** pandas, pyodbc
- **AI and NLP:** Sentence Transformers, scikit-learn
- **AI application:** Retrieval-Augmented Generation (RAG) and basic tool routing
- **Development tools:** VS Code, Git, GitHub
- **Visualization:** Power BI (planned extension)

## Business Questions

The project investigates questions such as:

- What proportion of orders are delivered on time?
- Which cities have the lowest on-time delivery rates?
- How do delivery outcomes vary by hour?
- What are the cancellation and stockout rates?
- How can operational findings be translated into testable recommendations?

Additional SQL scripts examine store performance, picker availability, category-level trends, and cancellation patterns.

## Dataset

The project uses two synthetic CSV files:

- `stores.csv` — store-level information
- `orders.csv` — order-level operational data

The dataset contains 10 stores and 5,000 orders.

The data is intended for demonstration and does not represent actual company operations.

## Repository Structure

```text
Quick-Commerce-Analytics/
├── ai/
│   ├── agent.py
│   ├── rag_pipeline.py
│   ├── test_rag.py
│   └── test_sql_connection.py
├── data/
│   ├── orders.csv
│   └── stores.csv
├── knowledge_base/
│   ├── project_documentation.md
│   └── verified_findings.md
├── python/
│   └── generate_data.py
├── sql/
│   ├── 01_create_tables.sql
│   ├── 02_data_validation.sql
│   ├── 03_store_performance.sql
│   ├── 04_delivery_delay_analysis.sql
│   ├── 05_picker_availability.sql
│   ├── 06_stockout_analysis.sql
│   ├── 07_hourly_performance.sql
│   ├── 08_category_analysis.sql
│   ├── 09_cancellation_analysis.sql
│   └── 10_executive_summary.sql
├── .gitignore
├── README.md
└── requirements.txt
```

## SQL Analytics

The SQL scripts cover:

1. Database and table creation
2. Data validation
3. Store-level performance
4. Delivery delays
5. Picker availability
6. Stockout analysis
7. Hourly performance
8. Category analysis
9. Cancellation analysis
10. Executive summary metrics

The queries are designed to turn order-level data into operational insights.

## Python and SQL Server Integration

Python connects to SQL Server using `pyodbc`.

The connection test verifies access to the `QuickCommerceDB` database and checks the `Stores` and `Orders` tables.

The AI agent uses predefined SQL queries for supported analytical questions rather than generating and executing arbitrary SQL from user input.

## Retrieval-Augmented Generation (RAG)

The RAG pipeline loads project documentation and verified findings from the `knowledge_base/` directory.

It then retrieves relevant text chunks using semantic similarity, helping the application answer questions grounded in the project's documentation.

The pipeline can display retrieved content and its source for inspection.

## AI Agent

The basic agent routes questions to different tools based on their intent:

- **Knowledge route:** retrieves relevant project documentation.
- **SQL route:** runs predefined analytical queries for supported metrics and operational questions.

This demonstrates a simple tool-routing workflow that combines structured database analysis with unstructured documentation retrieval.

The current implementation is a basic agent, not a fully autonomous production AI system.

## Initial Findings

The current SQL analysis has reported the following city-level on-time delivery rates:

| City | On-time delivery rate |
|---|---:|
| Noida | 62.05% |
| Gurugram | 62.95% |
| Jaipur | 67.09% |
| Ranchi | 67.22% |
| Mumbai | 67.37% |
| Kolkata | 67.65% |
| Hyderabad | 68.70% |
| Delhi | 69.04% |
| Bengaluru | 69.08% |
| Pune | 71.07% |

These rates are based on delivered orders in the synthetic dataset. They are descriptive results, not evidence of causal relationships or real-world company performance.

Other previously calculated metrics should be revalidated against the current database before being treated as final results.

## Operational Recommendation

A potential next step is to investigate whether improved picker allocation during evening hours could improve delivery reliability, particularly in lower-performing cities.

A controlled experiment could evaluate this proposal using:

- **Primary metric:** on-time delivery rate
- **Secondary metrics:** average picking time and cancellation rate
- **Guardrails:** staffing cost and order volume

A target such as a five-percentage-point improvement could be used as a proposed experiment goal. It is not a measured outcome of this project.

## Limitations

- The dataset is synthetic and does not represent real company data.
- The analysis identifies patterns but does not establish causality.
- Picker availability is represented at the level supported by the available dataset.
- Stockout indicators do not independently identify every affected product.
- The proposed operational experiment has not been conducted.
- Power BI dashboards are a planned extension unless separately implemented.

## Future Improvements

- Build interactive Power BI dashboards.
- Add more robust data validation and automated tests.
- Expand the AI agent's supported analytical questions.
- Improve routing and error handling.
- Add experiment evaluation using clearly defined metrics.
- Document reproducible database setup and execution steps.

## Author

**Vibhor Jain**  
Electronics and Communication Engineering  
Birla Institute of Technology, Mesra

GitHub: [VibhorJain1108](https://github.com/VibhorJain1108)

---

*This project is intended for learning and portfolio demonstration.*
