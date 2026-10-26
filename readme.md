# Quick Commerce Operations Analytics & AI Agent

An end-to-end portfolio project combining **Python, Microsoft SQL Server, SQL analytics, Retrieval-Augmented Generation (RAG), and an AI agent** to analyze operational performance in a simulated quick-commerce business.

## Project Overview

Quick-commerce platforms must balance fast delivery promises with reliable store operations. This project analyzes simulated order-level data to investigate delivery reliability, store performance, picker availability, stockouts, and cancellations.

The project also includes a documentation-based RAG pipeline and a tool-routing AI agent that directs questions to either the knowledge base or predefined, read-only SQL queries.

**Technology Stack:** Python, Microsoft SQL Server, SQL, pandas, pyodbc, Sentence Transformers, scikit-learn, Power BI (planned dashboard).

## Key Features

### 1. SQL-Based Operations Analytics

- Analyze delivery performance across stores and cities.
- Calculate on-time delivery and cancellation rates.
- Investigate picking time, picker availability, and stockout patterns.
- Compare operational performance by hour and product category.
- Translate findings into a measurable operations experiment.

### 2. Retrieval-Augmented Generation (RAG)

- Load project documentation and verified findings from a local knowledge base.
- Generate text embeddings using Sentence Transformers.
- Retrieve relevant documentation using similarity-based search.
- Return source-labelled excerpts to help answer project-related questions.

### 3. Tool-Routing AI Agent

- Route numerical and operational questions to predefined SQL queries.
- Route documentation and methodology questions to the RAG pipeline.
- Connect Python to Microsoft SQL Server using `pyodbc`.
- Return formatted results from the selected tool.

**Implementation note:** The current agent uses rule-based tool selection and predefined SQL queries. It is a foundational agentic-AI implementation, not a fully autonomous agent or a general-purpose natural-language-to-SQL system.

## Business Questions

- Which cities have the lowest on-time delivery rates?
- How does picker availability relate to delivery performance?
- Do picking times differ between on-time and late deliveries?
- Which hours have weaker delivery reliability?
- How do stockouts and cancellations vary across stores and categories?
- What are the limitations of the simulated dataset?
- What operational experiment could improve delivery performance?

## Dataset

The project uses synthetic data generated for learning and portfolio demonstration.

- **10 simulated stores**
- **5,000 simulated orders**
- Store identifiers, names, and city information
- Order timestamps, categories, item counts, and basket values
- Promised and actual delivery times
- Picking duration and picker availability
- Stockout and cancellation indicators
- Order status information

> **Disclaimer:** This is not real Blinkit data. The stores, orders, and findings are simulated and must not be interpreted as actual company performance.

## Initial Simulated Findings

The initial SQL analysis reported the following results:

| Metric | Result |
|---|---:|
| Total orders | 5,000 |
| Delivered orders | 4,812 |
| Cancelled orders | 188 |
| Cancellation rate | 3.76% |
| Overall on-time delivery rate | 67.21% |
| Noida on-time delivery rate | 62.05% |
| Gurugram on-time delivery rate | 62.95% |
| Pune on-time delivery rate | 71.07% |

These are previously reported results from the simulated dataset. They should be revalidated against the current SQL queries before being treated as final.

The initial hourly analysis also indicated weaker on-time delivery performance during evening hours.

These observations are descriptive and do not establish that picker availability, stockouts, or picking time cause delivery delays.

## Product and Operations Recommendation

Prioritize an investigation of evening fulfillment operations in Noida and Gurugram.

A proposed experiment is to test improved picker allocation during selected evening hours and compare delivery performance against an appropriate baseline or control group.

### Proposed Success Metrics

- **Primary metric:** On-time delivery rate.
- **Secondary metrics:** Average picking time and cancellation rate.
- **Guardrails:** Staffing cost per order and order volume served.
- **Proposed target:** Improve on-time delivery by five percentage points at each pilot store.

The five-percentage-point improvement is an experiment target, not a measured outcome or forecast.

## RAG and AI Agent Examples

The following are example questions supported by the project's current functionality.

### Knowledge-Base Questions

- What are the limitations of this dataset?
- How is on-time delivery rate calculated?
- What operational experiment is proposed?

### SQL-Oriented Questions

- How many orders are in the database?
- How many stores are in the database?
- Which cities have the lowest on-time delivery rates?
- What is the cancellation rate?
- What is the average picking time?

The agent currently routes questions using predefined keyword rules. Its query coverage depends on those rules and the available SQL functions.

## Repository Structure

```text
QuickCommerceAnalytics/
├── ai/
│   ├── agent.py
│   ├── rag_pipeline.py
│   ├── test_rag.py
│   └── test_sql_connection.py
├── data/
│   ├── stores.csv
│   └── orders.csv
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
├── requirements.txt
└── README.md
```

This represents the intended project structure. Update filenames if your actual repository differs.

## Setup and Execution

### Prerequisites

- Python 3.13 or a compatible Python version
- Microsoft SQL Server
- Microsoft ODBC Driver 18 for SQL Server
- Access to the `QuickCommerceDB` database
- VS Code or another Python editor

### 1. Clone the Repository

```bash
git clone <YOUR_GITHUB_REPOSITORY_URL>
cd QuickCommerceAnalytics
```

Replace the placeholder with your actual GitHub repository URL.

### 2. Install Dependencies

```bash
python -m pip install -r requirements.txt
```

### 3. Configure the Database Connection

The current local development configuration uses:

- **SQL Server instance:** `localhost\SQLEXPRESS`
- **Database:** `QuickCommerceDB`
- **Authentication:** Windows Trusted Connection
- **ODBC Driver:** 18

Ensure the database and required tables exist before running the agent. If you use another SQL Server instance, update the connection settings in the relevant Python file.

### 4. Test the SQL Connection

```bash
python ai/test_sql_connection.py
```

The test should report successful connectivity and display the store and order counts.

### 5. Test the RAG Pipeline

```bash
python ai/test_rag.py
```

The RAG pipeline uses a sentence-embedding model. The first execution may download model files and require an internet connection.

### 6. Run the AI Agent

```bash
python ai/agent.py
```

Enter a question when prompted. The agent selects either the SQL or knowledge-retrieval tool according to its routing rules.

##  Methodology

1. Generate synthetic store and order data using Python.
2. Load the data into Microsoft SQL Server.
3. Validate record counts, order statuses, and store relationships.
4. Analyze operational metrics using predefined SQL queries.
5. Document the project methodology, findings, and limitations.
6. Retrieve relevant documentation using embedding-based similarity search.
7. Route questions to the SQL or knowledge-retrieval tool.
8. Translate operational findings into a proposed experiment.

## Limitations

- The dataset is synthetic and may reflect assumptions in the data generator.
- Previously reported findings require revalidation against current SQL outputs.
- Picker availability is an order-level flag, not a complete staffing schedule.
- Stockout flags do not identify individual unavailable products.
- The dataset does not establish causal relationships.
- The agent uses keyword-based routing rather than an LLM-driven planner.
- SQL execution is restricted to predefined queries; arbitrary natural-language-to-SQL generation is not implemented.
- RAG retrieves relevant documentation but does not guarantee that every response is complete or factually correct.
- The proposed operational experiment has not been conducted.
- A Power BI dashboard remains a planned enhancement.

## Future Improvements

- Build an interactive Power BI dashboard with store, city, category, and time filters.
- Improve agent routing and add more approved analytical queries.
- Combine SQL results and retrieved documentation into a unified operations recommendation.
- Add automated evaluation cases for retrieval relevance, routing accuracy, and SQL correctness.
- Compare pilot and control stores using a defined evaluation period.
- Add dispatch and travel-time information for more realistic operational analysis.
- Document measured experiment results when available.

## Author

**Vibhor Jain**

B.Tech in Electronics and Communication Engineering  
Birla Institute of Technology, Mesra

- **GitHub:** [VibhorJain1108](https://github.com/VibhorJain1108)
- **Interests:** Data Analytics, Applied AI, RAG Systems, and Agentic AI

---

Created as a portfolio project demonstrating SQL analytics, Python development, retrieval-augmented generation, tool-routing AI, operational problem-solving, and product thinking.
